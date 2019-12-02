//
//  KannaTests.swift
//  ore-no-samurai-japanTests
//
//  Created by 白井　誠 on 2019/12/02.
//  Copyright © 2019 白井　誠. All rights reserved.
//

import XCTest
import Kanna

private let playersYbURL = URL(string: "https://baseball-data.com/player/yb/")!

/// HTMLパーサー"Kanna"の使い方説明を兼ねたテスト
///
/// セットアップや使い方については下記参照
/// - [Swift製HTMLパーサ「Kanna」](https://qiita.com/_tid_/items/c228b1931cd9b23d52d3)
class KannaTests: XCTestCase {

    /// [Kannaオブジェクトを作成](https://qiita.com/_tid_/items/c228b1931cd9b23d52d3#kanna%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%82%92%E4%BD%9C%E6%88%90)
    func testCreateHTMLObject() {

        func createHTMLFromURL(_ url: URL) -> HTMLDocument? {
            return try? HTML(url: url, encoding: .utf8)
        }
        XCTAssertNotNil(createHTMLFromURL(playersYbURL))

        func createHTMLfromHTMLString(_ htmlString: String) -> HTMLDocument? {
            return try? HTML(html: htmlString, encoding: .utf8)

        }
        XCTAssertNotNil(createHTMLfromHTMLString("<html>...</html>"))
    }

    /// [CSSセレクタで特定の要素を抽出する](https://qiita.com/_tid_/items/c228b1931cd9b23d52d3#css%E3%82%BB%E3%83%AC%E3%82%AF%E3%82%BF%E3%81%A7%E7%89%B9%E5%AE%9A%E3%81%AE%E8%A6%81%E7%B4%A0%E3%82%92%E6%8A%BD%E5%87%BA%E3%81%99%E3%82%8B)
    func testExtractNodes_CSS() {
        let doc = try! HTML(url: playersYbURL, encoding: .utf8)

        // HTML内のリンク(URL)を抜き出す
        for node in doc.css("a, link") {
            print(node["href"] as Any) // href属性に設定されている文字列を出力
        }
    }

    /// [Xpathで特定の要素を抽出する\(結果はCSSセレクタの場合と同じ\)](https://qiita.com/_tid_/items/c228b1931cd9b23d52d3#xpath%E3%81%A7%E7%89%B9%E5%AE%9A%E3%81%AE%E8%A6%81%E7%B4%A0%E3%82%92%E6%8A%BD%E5%87%BA%E3%81%99%E3%82%8B%E7%B5%90%E6%9E%9C%E3%81%AFcss%E3%82%BB%E3%83%AC%E3%82%AF%E3%82%BF%E3%81%AE%E5%A0%B4%E5%90%88%E3%81%A8%E5%90%8C%E3%81%98)
    func testExtractNodes_Xpath() {
        let doc = try! HTML(url: playersYbURL, encoding: .utf8)

        // HTML内のリンク(URL)を抜き出す
        for node in doc.xpath("//a | //link") {
            print(node["href"] as Any) // href属性に設定されている文字列を出力
        }
    }

    // 以降xpathのみ記載（cssでやりたい理由が特に思いつかないため）

    /// [属性値で絞り込む](https://qiita.com/_tid_/items/c228b1931cd9b23d52d3#%E5%B1%9E%E6%80%A7%E5%80%A4%E3%81%A7%E7%B5%9E%E3%82%8A%E8%BE%BC%E3%82%80)
    func testFilterByAttributeValue() {
        let doc = try! HTML(url: playersYbURL, encoding: .utf8)

        XCTAssertEqual(doc.xpath("//div[@id='main']/h2").first?.text,
                       "横浜DeNAベイスターズ選手一覧")
    }

    func testExtractLinkURL() {
        let doc = try! HTML(url: playersYbURL, encoding: .utf8)

        let node = doc.xpath("//*[@id='tbl']/tbody/tr[50]/td[2]").first!
        print(node.css("a[href]").first!["href"]!)
    }

    func testTableHeaders() {
        let doc = try! HTML(url: playersYbURL, encoding: .utf8)

        let tableHeaders = doc.xpath("//*[@id='tbl']/thead/tr/th")

        print(tableHeaders.count)
        tableHeaders.forEach({ print($0.text ?? "") })
    }

    func testPlayers() {
        let doc = try! HTML(url: playersYbURL, encoding: .utf8)

        let playerElements = doc.xpath("//*[@id='tbl']/tbody/tr")

        let players = playerElements.reduce([Player]()) { (result, playerElement) in
            return result + [Player(element: playerElement)]
        }
        players.forEach({ print($0) })
    }

    func testTeams() {

    }
}

enum League {
    case central
    case pacific
}

struct Team {
    /// チームコード
    let cd: String
    /// チーム名
    let name: String
    /// リーグ
    let league: League
}
struct Player {
    // TODO: いい感じに正規化したい。型も見直ししたい
    /// 背番号
    let no: String
    /// 選手名
    let name: String
    /// 選手詳細リンク
    let url: URL
    /// 守備
    let position: String
    /// 生年月日
    let birthday: String
    /// 年齢
    let age: String
    /// 年数
    let professionalYears: String
    /// 身長
    let height: String
    /// 体重
    let weight: String
    // TODO: enumかな？
    /// 血液型
    let bloodType: String
    /// 投打(batting/throw)
    let bt: String
    /// 出身地
    let prefectures: String
    /// 年俸(推定/万円)
    let salary: String
}

extension Player {
    init(element: XMLElement) {
        self.no = element.xpath("td[1]").first!.text!
        self.name = element.xpath("td[2]").first!.text!
        self.url = URL(string: element.xpath("td[2]").first!.css("a[href]").first!["href"]!)!
        self.position = element.xpath("td[3]").first!.text!
        self.birthday = element.xpath("td[4]").first!.text!
        self.age = element.xpath("td[5]").first!.text!
        self.professionalYears = element.xpath("td[6]").first!.text!
        self.height = element.xpath("td[7]").first!.text!
        self.weight = element.xpath("td[8]").first!.text!
        self.bloodType = element.xpath("td[9]").first!.text!
        self.bt = element.xpath("td[10]").first!.text!
        self.prefectures = element.xpath("td[11]").first!.text!
        self.salary = element.xpath("td[12]").first!.text!
    }
}
