//
//  FoodForm.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/31.
//Form 表格 类型

import Foundation
import SwiftUI

private enum MyField : Int{ //我的栏位
    case titleType,imageType,caloriesType,proteinType,fatType,carbType
}

private extension TextField where Label == Text{
    func focused(_ filed : FocusState<MyField?>.Binding , equals this : MyField) -> some View{
        submitLabel(this == .carbType ? .done: .next) // next设置
        .focused(filed,equals: this) //绑定栏位
        .onSubmit { //按下 next的行为
            filed.wrappedValue = .init(rawValue: this.rawValue + 1)
        }
    }
}

extension FoodListView{
    struct FoodForm : View{
        @Environment (\.dismiss) var dismiss
        @FocusState private var field : MyField?
        @State var food : Food
        var  onSubmit:(Food) -> Void
        
        private var isNotValid : Bool{ //不是 有效（Valid）的
            food.name.isEmpty || food.image.count > 2
        }
        private var invalidMessage : String?{ //invalid  无效
            if food.name.isEmpty { return "请输入名称"}
            if food.image.count > 2 {return "图示字数过多"}
            return .none
        }
        
        var body: some View{
            NavigationStack{
                VStack{
                    HStack{
                        Label("编辑食物咨询", systemImage: "pencil")
                            .font(.title.bold())
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                dismiss()
                            }
                    }.padding([.horizontal,.top])//只要水平和上面的间距
                    
                    
                    Form{
                        LabeledContent("名称") {
                            TextField("必填", text: $food.name)
                                .submitLabel(.next) // next设置
                                .focused($field,equals: .titleType) //绑定栏位
                                
                        }
                        LabeledContent("图示") {
                            TextField("最多输入2个字", text: $food.image)
                                .submitLabel(.next) // next设置
                                .focused($field,equals: .imageType) //绑定栏位
                        }
                        buildnumberField(title: "热量", value: $food.calorie,field: .caloriesType ,subffix: "大卡")
                        buildnumberField(title: "蛋白质", value: $food.protein,field: .proteinType)
                        buildnumberField(title: "脂肪", value: $food.fat,field: .fatType)
                        buildnumberField(title: "碳水化物", value: $food.carb,field: .carbType)
                    }.padding(.top , -16)
                    
                    Button {
                        dismiss()
                        onSubmit(food)
                    } label: {
                        Text(invalidMessage ?? "储存").frame(maxWidth: .infinity)
                            .bold()
                    }.mainButtonStyle()
                        .padding()
                        .disabled(isNotValid)
                    
                }.background(.groupBg)
                    .multilineTextAlignment(.trailing)
                    .font(.title3)
                    .scrollDismissesKeyboard(.interactively)//immediately马上关闭  interactively互动到影响键盘才关闭键盘
                    .toolbar { //toolbar 必须在Navigation下使用
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button(action: goPreviousField){
                                Image(systemName: "chevron.up")
                            }
                            Button(action: goNextField){
                                Image(systemName: "chevron.down")
                            }
                        }
                    }
            }
        }
        
        func goPreviousField(){
            guard let rawValue = field?.rawValue else{return}
            field = .init(rawValue: rawValue - 1)
        }
        func goNextField(){
            guard let rawValue = field?.rawValue else{return}
            field = .init(rawValue: rawValue + 1)
        }
        
        
        private func buildnumberField(title : String ,value : Binding<Double> ,field : MyField,subffix : String = "g") -> some View{
            LabeledContent(title) {
                HStack{
                    TextField("", value: value, format: .number.precision(.fractionLength(1)))//precision精确
                        .keyboardType(.decimalPad)
                        .focused($field, equals: field)
                    Text(subffix)
                }
            }
        }
    }
}

struct FoodForm_PreViews : PreviewProvider{
    static var previews: some View{
        FoodListView.FoodForm(food: Food.examples.first!)  {_ in}
    }
}
