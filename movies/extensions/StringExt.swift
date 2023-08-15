//
//  StringExt.swift
//  movies
//
//  Created by Dávid Váradi on 2023. 08. 10..
//

extension String {
    func extractPrimaryLanguageCode() -> String? {
        let components = self.components(separatedBy: "-")
        if let primaryCode = components.first {
            return primaryCode
        }
        return nil
    }
    
    func uppercasedFirstLetter() -> String {
        guard let firstLetter = first else { return self }
        
        return String(firstLetter).uppercased() + dropFirst()
    }
}
