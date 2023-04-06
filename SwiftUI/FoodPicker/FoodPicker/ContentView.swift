//
//  ContentView.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/27.
//

import SwiftUI


struct ContentView: View {
    //MARK: -   属性
    var screenBounds = UIScreen.main.bounds
    let foods = Food.examples
    @State private var selectFood : Food?
    @State private var isShowInfo : Bool = false
    
    var body: some View {
        ScrollView{
            VStack (spacing: 30){ //VStack 最多10个子view
                foodView
                
                Image(systemName: "globe")//地球🌍
                    .border(.yellow)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(Color.blue)
                    .imageScale(.large)
                    .padding(EdgeInsets(.init(top: -20, leading: 0, bottom: 0, trailing: 0)))
                
                Text("今天吃什么？").bold()
                Spacer().layoutPriority(1) // layoutPriority 优先级
                selectFoodInfoView
                changeBtn
                cancelBtn
                
            }
            .padding() //位置很重要
            .frame(minWidth: screenBounds.width, maxWidth: .infinity,minHeight: screenBounds.height,maxHeight: .infinity)//infinity  尽量大的     搭配 controlSize(.large)
            .background(Color.bg2)
            .font(.title) //VStack默认
            .animation(.mySpring,value: isShowInfo)
            .animation(.mySpring, value: selectFood)
            .mainButtonStyle()
        }
    }
}

    //MARK: -   Subviews
    private extension  ContentView{
        var foodView : some View {
            Group{
                if let  selectFood {
                    Text(selectFood.image)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.7)//缩小
                        .lineLimit(1)
                }
                else{
                    Image("aboutIcon")
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .padding(.horizontal, 20.0)
                        .frame(width: 200)
                }
            }.frame(height: 250)
                .border(.yellow)
                .padding(EdgeInsets(.init(top: 20, leading: 0, bottom: 0, trailing: 0)))
        }
        
        var foodNameView : some View {
            HStack{
                Text(selectFood!.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
                    .id(selectFood!.name)
                //opacity  不透明
                    .transition(.delayInsertionOpacity)
                
                Button {
                    isShowInfo.toggle()//toggle切换
                } label: {
                    Image("circle")
                        .resizable() //变大
                        .font(.largeTitle).foregroundColor(.black).frame(width: 30,height: 30).border(.cyan)
                    //                        .aspectRatio(contentMode: .fill)
                }.buttonStyle(.plain)
            }
        }
        
        var foodDetailView : some View {
            HStack{
                VStack(spacing: 12){
                    Text("蛋白质")
                    Text(selectFood!.$protein)
                }
                Divider().frame(width: 2,height: 40).background(.black).padding(.horizontal)
                VStack(spacing: 12){
                    Text("脂肪")
                    Text(selectFood!.$fat)
                }
                Divider().frame(width: 1,height: 30).background(Color(.black)).padding(.horizontal)
                VStack(spacing: 12){
                    Text("碳水化物")
                    Text(selectFood!.$carb)
                }
            }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
        }
        
        @ViewBuilder var selectFoodInfoView : some View {
            if let selectFood{
                foodNameView
                
                Text("热量  \(selectFood.$calorie)").fixedSize(horizontal: true, vertical: true)//fixedSize 横竖 优先显示 优先撑开
                foodDetailView
                
                if isShowInfo {
                    Grid (horizontalSpacing: 12,verticalSpacing: 0){
                        GridRow{
                            Text("蛋白质")
                            Rectangle().frame(width: 1).foregroundColor(.secondary)
                            Text("脂肪")
                            Text("碳水化物").minimumScaleFactor(0.5)
                        }.font(.system(size: 25))
                        
                        Divider().gridCellUnsizedAxes(.horizontal)
                            .padding(.horizontal,30)
                        
                        GridRow{
                            buildNumberText(_number: selectFood.protein)
                            Rectangle().frame(width: 1).foregroundColor(.secondary)
                            buildNumberText(_number: selectFood.fat)
                            buildNumberText(_number: selectFood.carb)
                        }
                    }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(.bg))
                }
            }
            
        }
        
        var changeBtn : some View {
            Button(role: .none) {
                selectFood = foods.shuffled().filter{
                    $0 != selectFood
                }.first
            } label: {
                Text(selectFood == nil ? "告诉我！": "换一个").frame(width: 150,height: 30,alignment: .center)
                    .transformEffect(.init(translationX: 0, y: 0))
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)//capsule 胶囊
            .padding(.bottom,-25)//挨着重置了
            //            .controlSize(.large) //会变大
        }
        
        var cancelBtn : some View {
            Button(role: .cancel) {
                selectFood = nil
                isShowInfo = false
            } label: {
                Text("重置").frame(width: 150)
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 20))// roundedRectangle 矩形
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        }
        
    }

//MARK: -   Action
func buildNumberText (_number : Double) -> some View
{
    Text(_number.formatted() + "g")
}

extension ContentView {
    init(selectedFood : Food) {
        _selectFood = State(wrappedValue: selectedFood)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedFood: .examples.first!)
    }
}
