# MyDemos
A project about some demos for learning iOS development.（Some of them are imitating others）



## 主界面

![main](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/main.png)

该界面使用 UITableView 展示项目所包含的所有 Demo，并通过 UISearchController 实现了对 TableViewCell 内容的搜索。在该界面的实现过程中我进一步熟练了 UITableView 的使用方法，同时学习了 UISearchController 在结合 UITableView 时的基本用法：

```swift
// 1. 获取 UISearchController 实例对象 
let searchController = UISearchController(searchResultsController: nil) 
// 	参数 nil 表示使用相同的 View 来展示搜索结果


// 2. 设置 SearchController 相关属性
searchController.searchResultsUpdater = self 
// 	设置当前 ViewController 为更新搜索结果的对象，SearchBar 的 text 改变时会接到通知，作用类似 		searchBar(searchBar: UISearchBar, textDidChange searchText: String) 这一代理方法
searchController.dimsBackgroundDuringPresentation = false
//	该属性为 true 时会暗化前一个 View，使其无法响应用户操作
definesPresentationContext = true 
// 	确保当SearchBar处于激活状态时，点击cell跳转时不会遗留SearchBar在界面上


// 3. 获取 SearchBar 并将其设置为 TableView 的 HeaderView, 并且设置 SearchBar 的样式和 delagate
tableView.tableHeaderView = searchController.searchBar
searchController.searchBar.scopeButtonTitles = ["All", "Easy", "Normal", "Hard"]
// 	设置搜索条下面的 SegmentedControl 标题
searchController.searchBar.delegate = self


// 4. 实现搜索逻辑功能部分
//	首先，SearchBar 有几个常用的代理方法：
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
// 	searchText 改变时调用
func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
//	selectedScopeButton 改变时调用

// 其次，还有一个 UISearchResultsUpdating protocol可供使用，它只包含一个必须实现的方法，用来响应 searchBar 状态的改变
func updateSearchResults(for searchController: UISearchController) 
// 经过我对比后发现，它与 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) 唯一的区别是：searchBar 在未激活状态与激活状态之间切换时会单独调用 updateSearchResults()，即点击搜索栏进入搜索状态和点击 Cancel 退出搜索状态这两个时刻。除此外，当 searchText 改变时，两者都会被调用

// 在具备了这些知识后就可以很容易实现搜索的逻辑功能了
// (1) 实现 filterContentForSearchText 方法来将用户输入和选择的 Scope 与被搜索对象进行匹配，过滤掉不  	满足条件的。这里们将“难度”不匹配或者名字中不包含用户输入串的内容过滤掉，并在 searchBar 和 scope 改变 	时调用它来更新搜索结果
func filterContentForSearchText(_ searchText: String, scope: String = "All") {
     filteredDemos = demos.filter { demo in
         let levelMatch = (scope == "All") || (demo.level == scope)
         return levelMatch && (demo.name.lowercased().contains(searchText.lowercased()) || searchText == "")
     }
     tableView.reloadData()
}

// (2) 注意，在实现 UITableView 的代理方法 numberOfRowsInSection 和 cellForRowAtIndexPath 时要 	做出相应的判断：除了 scope = "All" && text = "" 时使用 demos[]，其他都使用 filteredDemos[]
```



## Learn UITableView

![severalsections](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/severalsections.png)

![todo](/Users/stone/Desktop/MyDemos/PicturesForREADME/todo.png)

这个 Demo 练习了最简单的 UITableView 使用，包括：基本的多 Section TableView，和基础的 Add，Delete，Move TableViewCell 的操作等。



## DrawingBoard

![drawingBoard](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/drawingBoard.png)

DrawingBoard 这个 Demo 是一个简单的画板应用，实现了自定义画笔粗细颜色，和一些图形的绘制，以及对画板上各图形元素的选中、平移操作。其中在绘制多边形(正多边形)时，用户可自定义边数，默认为3，如下：

![drawingBoard1](/Users/stone/Desktop/MyDemos/PicturesForREADME/drawingBoard1.png)

Demo 中用到了以下知识点：

- 基本控件的使用，如：Button、TextField、SegmentedControl、Slider
- 页面布局中使用 StackView 及 AutoLayout，页面跳转使用 Present Modally Segue，并使用 UINavigationController 进行导航控制
- 使用 CGContext 和 UIBezierPath 进行绘图
- 使用 UIGestureRecognizer 实现 tap(选中) 和 move(平移) 操作





## StopWatch

![stopWatch](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/stopWatch.png)

StopWatch 是网上例子的模仿 Demo，主要练习了 StackView 及 AutoLayout ，以及简单的自定义 Button 方法。

包含的新知识：

- 使用 Timer.scheduledTimer 设置定时器（参考：[timer的预订和注销，以及释放](http://www.wangzhengdong.com/blog/iOS-nstimer-invalidate-and-release.html)）

  >  在它的 Selector 参数传递每次计时动作发生时需要调用的方法(如: update操作)，需要extension Selector 如下：

  ```swift
  fileprivate extension Selector {
      static let updateMainTimer = #selector(ViewController.updateMainTimer)
      static let updateLapTimer = #selector(ViewController.updateLapTimer)
  }
  ```

  > Timer.invalidate(); //注销，即让timer失效
  >
  > Timer.release(); //释放（通常不需要这一步）

- 为了避免在滑动 TableView 时 Timer 的工作受到影响，需要将 Timer 加入 NSRunLoopCommonModes 中，因为 Timer 默认是在 NSDefalutRunLoopMode 里的，而当用户滑动 ScrollView 时， RunLoop 会将切换为 TrackingRunLoopMode，此时 Timer 就不会被回调。解决办法有两种：一种办法就是将这个 Timer 分别加入这两个 Mode；另一种是将 Timer 加入到 RunLoop 的 commonModelItems 中，commonModeItems 被 RunLoop 自动更新到所有具有 Common 属性的 Mode 里去。

  ```swift
  RunLoop.current.add(self.lapStopWatch.timer, forMode: .commonModes)
  ```

- 关于 RunLoop，目前我还是一知半解，之后仍需更深的学习（参考：[RunLoop](http://blog.ibireme.com/2015/05/18/runloop/)）




## WeiChat TableView

![weichat](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/weichat.png)

WeiChat TableView 是利用 UITableView 来模仿微信聊天界面的 Demo，主要联系了自定义 Cell 的方法。

注意点：

- 定义合适的消息数据结构，包含：消息的发送者信息，发送时间，消息内容View（文本或图片等）
- 根据消息内容自适应 Cell 高度和 气泡图片大小等



## Photo Scroll

![photoscroll0](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/photoscroll0.png)

![photoscroll1](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/photoscroll1.png)

Photo Scroll 是一个模仿别人的 Demo，练习了 UICollectionViewController 和 UIPageViewController 的使用。

主要内容：

- 使用 UICollectionViewController 实现了类似相册的 Controller 来展示每个 Cell
- 使用 UIPageViewController 实现了左右滑动来查看每个单项具体内容
- 用 UIImageView 实现 UIScrollViewDelegate 代理方法，以实现图片的缩放查看



## Collection Demo1 & Interests

![collectiondemo](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/collectiondemo.png)

![interests](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/interests.png)

Collection Demo1 & Interests 都是练习 UICollectionView 的 Demo。

其中：

- Collection Demo1 练习了使用 UICollectionViewLayout 来自定义较复杂的界面
- Interests 分别使用了 普通的 UICollectionViewFlowLayout 和 自定义的类似画廊的布局方式来展现 CollectionView，并可通过点击 “切换” 按钮来互相转换



## Alamofire Demo

![alamofiredemo](https://github.com/StoneN/MyDemos/tree/master/PicturesForREADME/alamofiredemo.png)

Alamofire Demo 是一个练习使用 Alamofire 来实现下载功能的 Demo。它实现了在下载过程中暂停，继续，取消下载的功能，并能在意外断网，又修复网络连接后恢复下载。
