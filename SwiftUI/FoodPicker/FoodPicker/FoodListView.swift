//
//  FoodListView.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/30.
//

import Foundation
import SwiftUI

private enum SheetType : View,Identifiable{
    case newFood((Food) -> Void)
    case editFood(Binding<Food>)
    case foodDetail(Food)
    
    var id: UUID{
        switch self {
        case .newFood:
            return UUID()
        case .editFood(let binding):
            return binding.wrappedValue.id
        case .foodDetail(let food):
            return food.id
        }
    }
    
    var body: some View{
        switch self {
        case .newFood(let onSubmit):
            FoodListView.FoodForm(food: .newFood, onSubmit: onSubmit)
        case .editFood(let binding):
            FoodListView.FoodForm(food: binding.wrappedValue){ binding.wrappedValue = $0 }
        case .foodDetail(let food):
            FoodListView.FoodDetailSheet(food: food)
        }
    }
}

struct FoodListView : View {
    //MARK: -   属性
    @Environment(\.editMode) var editMode   // 读取环境 编辑状态
    @Environment(\.dynamicTypeSize)  var textSize  // 读取环境 字体大小
    
    //@State  大概是状态监听的意思
    @State private var foodArr  = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()
    @State private var foodDetailHeight :CGFloat = FoodDetailSheetHeightKey.defaultValue
    //1 替换2
    @State private var sheet : SheetType?
    //2
//    @State private var shouldShowSheet : Bool  =  false
//    @State private var shouldShowFoodForm : Bool = false
//    @State private var selectedFood : Binding<Food>!
    
    var isEditing : Bool {
        editMode?.wrappedValue == .active
    }
    
    var body: some View{
        VStack (alignment: .leading){
            titleBar
            
            List($foodArr, editActions: .all,selection: $selectedFoodID,rowContent: buildFoodRow)
                .listStyle(.plain)
                .padding(.horizontal)
                .border(.red)
                .background(.groupBg)
            //安全区下面 添加按钮  添加了 content+func  就无法使用{}了
            //        .safeAreaInset(edge: .bottom){
            //
            //        }
                .safeAreaInset(edge: .bottom,content : buildFloatBtn)
                .sheet(item: $sheet){$0}
            //        .sheet(item: $selectedFood, content: { tempFood in
            //            FoodForm(food: tempFood.wrappedValue){ tempFood.wrappedValue = $0
            //            }
            //        })
            //        .sheet(isPresented: $shouldShowFoodForm, content: {
            //            FoodForm(food: Food(name: "", image: "")) { food in
            //                self.foodArr.append(food)
            //            }
            //        })
            //        .sheet(isPresented: .constant(shouldShowSheet)) {
            //            let food = foodArr[4]
            //            let shouldVstack = textSize.isAccessibilitySize || food.image.count > 1
            ////            let layout = shouldVstack ? AnyLayout(VStackLayout(spacing: 30)) : AnyLayout(HStackLayout(spacing: 30)) // AnyLayout  专门条件排版
            //            AnyLayout.userVstack(if: shouldVstack, spacing: 30){
            //                Text(food.image).font(.system(size: 100)).lineLimit(1).minimumScaleFactor(shouldVstack ? 1:0.5)
            //                Grid(horizontalSpacing: 30,verticalSpacing: 12){
            //                    buildNutriionView(title: "热量", value: food.$calorie)
            //                    buildNutriionView(title: "蛋白质", value: food.$protein)
            //                    buildNutriionView(title: "脂肪", value: food.$fat)
            //                    buildNutriionView(title: "碳水化物", value: food.$carb)
            //                }
            //            }
            //            .padding()
            //                .padding(.vertical)
            //                .overlay{
            //                    GeometryReader{ proxy in
            //                        Color.clear.preference(key: FoodDetailSheetHeightKey.self, value: proxy.size.height)
            //                    }
            //                }
            //                .onPreferenceChange(FoodDetailSheetHeightKey.self){
            //                    foodDetailHeight = $0
            //                }
            //                .presentationDetents([.height(foodDetailHeight)])
            //        }
        }
    }
    
    //MARK:   方法
    func buildFoodRow(foodBinding : Binding<Food>) -> some View{
        let food = foodBinding.wrappedValue
        return   HStack{
            HStack{
                Text(food.name)
                Text(food.image)
            }.padding(.vertical,10)
                .border(.red)
                .frame(maxWidth: .infinity,alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture{//点击食物 显示细节
                    if isEditing {
                        selectedFoodID.insert(food.id)
                        return
                    }
                    sheet = .foodDetail(food)
                    //                    shouldShowSheet = true
                }
            
            if isEditing{
                Image(systemName: "pencil").font(.title2.bold()).foregroundColor(.accentColor)
                    .onTapGesture {//编辑食物
                        sheet = .editFood(foodBinding)
                    }
            }
        }
    }

    //MARK:   子视图
    func buildFloatBtn() -> some View {
        ZStack{
            removeBtn.transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
                .opacity(isEditing ? 1:0)
                .id(isEditing)
            HStack{
                Spacer()
                addButton.scaleEffect( isEditing ? 0.1:1) //scaleEffect 动画不能从0 开始 所以0.1
                    .opacity(isEditing ? 0:1)
                    .animation(.easeInOut, value: isEditing)
            }
        }
    }
    
    var titleBar : some View {
        HStack{
            Label("食物清单", systemImage: "fork.knife")
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)//leading主要的
                .padding()
            
            EditButton().buttonStyle(.bordered).padding() //bordered有边框的
                .environment(\.locale, .init(identifier: "zh"))//environment环境
        }
    }
    var addButton : some View{
        Button {
            sheet = .newFood{
                self.foodArr.append($0)
            }
//            shouldShowFoodForm = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .padding()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white,Color.accentColor.gradient)//gradient坡度
        }
    }
    
    var removeBtn : some View{
        Button {
            withAnimation {
                foodArr = foodArr.filter{!selectedFoodID.contains($0.id)}
            }
            
        } label: {
            Text("删除已选项目")
                .font(.title2.bold())
                .frame(maxWidth: .infinity,alignment: .center)
        }
        .mainButtonStyle(shape: .roundedRectangle(radius: 8))
        .padding(.horizontal,50)//横向留白50
    }
}

//MARK: -   分类
private extension FoodListView{
    struct FoodDetailSheetHeightKey : PreferenceKey {
        static var defaultValue : CGFloat = 300
        static func reduce(value : inout CGFloat ,nextValue : () -> CGFloat){
            value = nextValue()
        }
    }
    struct FoodDetailSheet : View{
        @Environment(\.dynamicTypeSize) private var textSize  // 读取环境 字体大小
        @State private var foodDetailHeight :CGFloat = FoodDetailSheetHeightKey.defaultValue
        
        let food : Food
        var body: some View{
            let shouldVstack = textSize.isAccessibilitySize || food.image.count > 1
//            let layout = shouldVstack ? AnyLayout(VStackLayout(spacing: 30)) : AnyLayout(HStackLayout(spacing: 30)) // AnyLayout  专门条件排版
            AnyLayout.userVstack(if: shouldVstack, spacing: 30){
                Text(food.image).font(.system(size: 100)).lineLimit(1).minimumScaleFactor(shouldVstack ? 1:0.5)
                
                Grid(horizontalSpacing: 30,verticalSpacing: 12){
                    buildNutriionView(title: "热量", value: food.$calorie)
                    buildNutriionView(title: "蛋白质", value: food.$protein)
                    buildNutriionView(title: "脂肪", value: food.$fat)
                    buildNutriionView(title: "碳水化物", value: food.$carb)
                }
            }
            .padding()
                .padding(.vertical)
                .overlay{
                    GeometryReader{ proxy in
                        Color.clear.preference(key: FoodDetailSheetHeightKey.self, value: proxy.size.height)
                    }
                }
                .onPreferenceChange(FoodDetailSheetHeightKey.self){
                    foodDetailHeight = $0
                }
                .presentationDetents([.height(foodDetailHeight)])
        }
        
        //MARK:   方法
        //Nutriion 营养
        func buildNutriionView(title : String,value : String) -> some View{
            GridRow{
                Text(title).gridCellAnchor(.leading)
                Text(value).gridCellAnchor(.trailing)
            }
        }
    }
}
