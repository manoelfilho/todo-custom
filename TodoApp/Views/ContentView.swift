//
//  ContentView.swift
//  TodoApp
//
//  Created by Manoel Filho on 26/06/21.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: Properties
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    @State private var showingAddTodoView: Bool = false
    
    @EnvironmentObject var iconSettings: IconNames
    
    @State private var showingSettingsView: Bool = false
    
    //MARK: THEME
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    //MARK: Functions
    private func deleteTodo(at offsets: IndexSet){
        for index in offsets{
            let todo = todos[index]
            managedObjectContext.delete(todo)
            do{
                try managedObjectContext.save()
            }catch{
                print(error)
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "Alta":
            return .pink
        case "Normal":
            return .green
        case "Baixa":
            return .blue
        default:
            return .gray
        }
    }
    
    //MARK: Body
    var body: some View {
        
        NavigationView{
            
            ZStack {
                List{
                    ForEach(self.todos, id: \.self){ todo in
                        HStack{
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            
                            Text(todo.name ?? "--Sem título--")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "--Não definida--")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(5)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }
                        .padding(.vertical, 10)
                    }//: Final of the Foreach
                    .onDelete(perform: deleteTodo)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Tarefas", displayMode: .large)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button( action: {
                        self.showingSettingsView.toggle()
                    } ){
                        Image(systemName: "paintbrush").imageScale(.large)
                    }
                    .sheet(
                        isPresented: $showingSettingsView
                    ){
                        SettingsView().environmentObject(self.iconSettings)
                    }
                )
                
                //MARK: NO TODO ITENS
                if todos.count == 0 {
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddTodoView){
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    
                    Group{
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(0.2)
                            .frame(width: 68, height: 68, alignment: .center)
                        
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(0.15)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    
                    Button(
                        action: {
                            self.showingAddTodoView.toggle()
                        }
                    ){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(
                                Circle().fill(Color("ColorBase"))
                            )
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                }
                .padding(.bottom, 15)
                .padding(.trailing, 15),
                alignment: .bottomTrailing
            )
            
        } //: Final of NavigationView
        .accentColor(themes[self.theme.themeSettings].themeColor)
        
    }
    
    
}

//MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //para acessar o contexto em previews
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
