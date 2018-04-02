//
//  Router.swift
//  Router
//
//  Created by Red Davis on 30/03/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import Foundation


public final class Router
{
    // Private
    private var routes = [Route]()
    
    // MARK: Initialization
    
    public required init()
    {
        
    }
    
    // MARK: Routes
    
    public func register(route: Route)
    {
        self.routes.append(route)
    }
    
    public func handle(url: URL) -> Bool
    {
        let matchedRoutes = self.routes.filter { (route) -> Bool in
            return route.matches(path: url.path)
        }
        
        guard let route = matchedRoutes.first else
        {
            return false
        }
        
        return route.handle(url: url)
    }
}
