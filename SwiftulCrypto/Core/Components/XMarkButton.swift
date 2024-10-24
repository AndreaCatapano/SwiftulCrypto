//
//  XMarkButton.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 23/10/24.
//

import SwiftUI

struct XMarkButton : View {
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
                Image(systemName: "xmark")
                .font(.headline) })
    }
}


struct PXMarkButton_Prreviews: PreviewProvider{
    static var previews: some View{
        XMarkButton()
    }
}
