//
//  AddTodoView.swift
//  TodoApp
//
//  Created by Manoel Filho on 26/06/21.
//

import SwiftUI

struct AddTodoView: View {
    
    //MARK: Properties
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    let priorities = ["Alta", "Normal", "Baixa"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    //MARK: THEME
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    //MARK: Body
    var body: some View {
    
        NavigationView{
            
            VStack {
                
                VStack(alignment: .leading, spacing: 20){
                    
                    //MARK: TODO NAME
                    TextField("Tarefa", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .cornerRadius(9)
                    
                    
                    //MARK: TODO PRIORITY
                    Picker("Prioridade", selection: $priority){
                        ForEach(self.priorities, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    //MARK: SAVE BUTTON
                    Button(
                        action: {
                            if self.name != "" {
                                
                                let todo = Todo(context: managedObjectContext)
                                todo.name = self.name
                                todo.priority = self.priority
                                
                                do{
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error)
                                }
                                
                            }else{
                                self.errorShowing = true
                                self.errorTitle = "Nome inválido"
                                self.errorMessage = "Verifique o título informado"
                                return
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    ){
                        Text("Salvar".uppercased())
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Spacer()
            
            } //: End of VStack
            .navigationBarTitle("Nova tarefa", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                ){
                    Image(systemName: "xmark")
                }
            )
            .alert(isPresented: $errorShowing){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
        } //: End of NavigationView
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}

//MARK: Preview
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
