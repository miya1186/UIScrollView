//
//  ViewController.swift
//  UIScrollView
//
//  Created by miyazawaryohei on 2020/10/09.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    
    struct Photo {
        var imageName:String
        var tittle:String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoList = [
            Photo(imageName: "photo1", tittle: "映画は中劇"),
            Photo(imageName: "photo2", tittle: "札幌は時計台"),
            Photo(imageName: "photo3", tittle: "蓮の花"),
            Photo(imageName: "photo4", tittle: "夏の垣根")
        ]
        //サブビューの作成
        let subView = createCotentsView(contentList:photoList)
        scrollView.addSubview(subView)
        //スクロールビューの設定
        scrollView.isPagingEnabled = true //ページ送るにする
        scrollView.contentSize = subView.frame.size//コンテンツサイズ
        scrollView.contentOffset = CGPoint(x: 0, y: 0)//スクロール開始位置
        scrollView.delegate = self
        
        //ページコントロールを設定
        pageControl.numberOfPages = photoList.count
        pageControl.currentPage = 0
        //ページコントロールのドットの色
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
    }
    //スクロールビューに追加するコンテンツビュー（サブビュー）を作成
    func createCotentsView(contentList:Array<Photo>) -> UIView {
        //ページを追加するコンテンツビューを作成
        let cotentView = UIView()
        //1ページの幅と高さ（縦はデバイスで変化するのでviewに合わせる）
        let pageWidth = self.view.frame.width
        let pageHigth = scrollView.frame.height
        let pageViewRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHigth)
        //写真の縦横サイズ（正方向）
        let photoSize = CGSize(width: 250, height: 250)
        //ページを並べたコンテンツビュー全体のサイズ
        cotentView.frame = CGRect(x: 0, y: 0, width: pageWidth*4, height: pageHigth)
        //ページの背景色
        let colors:Array<UIColor> = [.cyan, .yellow, .lightGray,.orange]
        //写真のコンテンツのページを作ってコンテンツビューに追加する
        for i in 0..<contentList.count {
            //写真のファイル名とタイトルを順に取り出す
            let contentItem = contentList[i]
            //ページのビューを作る
            let pageView = createPage(viewRect: pageViewRect, imageSize: photoSize, item: contentItem)
            //ページの表示座標を決める(ページ幅だけずらしていく）
            let left = pageViewRect.width * CGFloat(i)
            let xy = CGPoint(x: left, y: 0)
            pageView.frame = CGRect(origin: xy, size: pageViewRect.size)
            pageView.backgroundColor = colors[i]
            //コンテンツビューにページビューを並べて追加していく
            cotentView.addSubview(pageView)
        }
        return cotentView
        
    }
    
    //写真とタイトルがある１ページ分のビューを作る
    func createPage(viewRect:CGRect, imageSize:CGSize, item:Photo) -> UIView {
        let pageView = UIView(frame: viewRect)
        //写真ビューを作ってイメージを設定する
        let photoView = UIImageView()
        let left = (pageView.frame.width - imageSize.width)/2
        photoView.frame = CGRect(x: left, y: 10, width: imageSize.width, height: imageSize.height)
        photoView.contentMode = .scaleAspectFill
        photoView.image = UIImage(named: item.imageName)
        //ラベルを作って写真タイトルを設定する
        let titleFrame = CGRect(x: left, y: photoView.frame.maxY+10, width: 200, height: 21)
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = item.tittle
        //写真とタイトルとページビューに追加する
        pageView.addSubview(photoView)
        pageView.addSubview(titleLabel)
        return pageView
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //カレンとページを調べる
        let pageNo = Int(scrollView.contentOffset.x/scrollView.frame.width)
        //表示をカレンとページに合わせる
        pageControl.currentPage = pageNo
    }
}

