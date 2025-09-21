//
//  asdasd.swift
//  ShoppingBuddy
//
//  Created by Jarede Lima on 20/09/25.
//


    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: value)) ?? "R$ 0,00"
    }
    