//
//  Route.swift
//  Router
//
//  Created by Red Davis on 30/03/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import Foundation


public struct Route
{
    // Internal
    
    // Private
    private let path: String
    private let components: [Component]
    private let handler: (_ attributes: [String : String]) -> Bool
    
    // MARK: Initialization
    
    public init(path: String, handler: @escaping (_ attributes: [String : String]) -> Bool)
    {
        self.path = path
        self.handler = handler
        self.components = Component.parse(path: path)
    }
    
    // MARK: Matches
    
    public func matches(path: String) -> Bool
    {
        let otherComponents = Component.parse(path: path)
        if self.components.count != otherComponents.count
        {
            return false
        }
        
        var index = 0
        for otherComponent in otherComponents
        {
            let component = self.components[index]
            switch (component, otherComponent)
            {
            case (.path(let valueA), .path(let valueB)):
                if valueA != valueB
                {
                    return false
                }
            default:()
            }
            
            index += 1
        }
        
        return true
    }
    
    // MARK: URL
    
    internal func handle(url: URL) -> Bool
    {
        guard self.matches(path: url.path),
              let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else
        {
            return false
        }
        
        var attributes = [String : String]()
        
        // Extract path attributes
        let otherComponents = url.path.split(separator: "/")
        var index = 0
        for component in self.components
        {
            switch component
            {
            case .variable(let key):
                attributes[key] = String(otherComponents[index])
            default:()
            }
            
            index += 1
        }
        
        // Query parameters
        urlComponents.queryItems?.forEach({ (item) in
            guard let value = item.value else
            {
                return
            }
            
            attributes[item.name] = value
        })
        
        // Call handler
        return self.handler(attributes)
    }
}


// MARK: Component

fileprivate extension Route
{
    fileprivate enum Component
    {
        case path(value: String)
        case variable(name: String)
        
        // MARK: Static
        
        fileprivate static func parse(path: String) -> [Component]
        {
            return path.split(separator: "/").map({ (substring) -> Component in
                return Component(string: String(substring))
            })
        }
        
        // MARK: Initialization
        
        fileprivate init(string: String)
        {
            if string.first == ":"
            {
                var mutableString = string
                mutableString.removeFirst()
                
                self = .variable(name: mutableString)
                return
            }
            
            self = .path(value: string)
        }
    }
}
