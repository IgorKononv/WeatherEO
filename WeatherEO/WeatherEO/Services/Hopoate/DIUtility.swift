//
//  DIUtility.swift
//
//  Created by Igor Kononov on 26.10.2022.
//

import Foundation

@discardableResult
public func register<Service>(service: Service.Type, cacheService: Bool = true, creator: @escaping () -> Service) -> ServiceRegistration<Service> {
    return DependencyContainer.shared.register(service: service, cacheService: cacheService, creator: creator)
}
