# HatenaKeywordLink プラグイン

エントリー本文などをはてなダイアリーキーワードに自動的にリンクするプラグイン。

## 更新履歴

 * 0.01 (2006-11-27 15:07:53 +0900):
   * 公開。
 * 0.02 (2006-11-27 15:13:52 +0900):
   * MTHatenaKeywordLinkコンテナタグを追加。

## 概要

(すでに同種のプラグインがあった気がしますが) [はてなダイアリーキーワード自動リンクAPI](http://d.hatena.ne.jp/keyword/%a4%cf%a4%c6%a4%ca%a5%c0%a5%a4%a5%a2%a5%ea%a1%bc%a5%ad%a1%bc%a5%ef%a1%bc%a5%c9%bc%ab%c6%b0%a5%ea%a5%f3%a5%afAPI)を用いて、エントリー本文などに含まれるキーワードを自動抽出し、はてなダイアリーキーワードにリンクするプラグインです。

## インストール方法

プラグインをインストールするには、パッケージに含まれるpluginsディレクトリの中身をMovable Typeのプラグインディレクトリにアップロードもしくはコピーしてください。

下のようなディレクトリ構造になります。

    MTDIR/plugins/HatenaKeywordLink/
    MTDIR/plugins/HatenaKeywordLink/HatenaKeywordLink.pl
    MTDIR/plugins/HatenaKeywordLink/tmpl/
    MTDIR/plugins/HatenaKeywordLink/tmpl/config.tmpl

正しくインストールできていれば、Movable Typeのメインメニューのプラグイン一覧に!HatenaKeywordLink Pluginが新規にリストアップされます。 

## 追加されるテンプレートタグ・フィルタ

### MTHatenaKeyworkLinkコンテナ

指定した範囲のレンダリング結果をはてなダイアリーキーワードに自動リンクします。

使用例:

    <MTHatenaKeywordLink>
    
    <p>指定した範囲のテキストをはてなダイアリーキーワードに自動リンクします。</p>
    
    <MTEntries lastn="5">
    <p><$MTEntryTitle$>: <$MTEntryBody$></p>
    </MTEntries>
    
    </MTHatenaKeywordLink>

### hatena_keyword_linkグローバルフィルタ

特定のコンテナタグ・変数タグのレンダリング結果をはてなダイアリーキーワードに自動リンクします。

使用例:

    <MTEntries lastn="5">
    <p><$MTEntryTitle$>: <$MTEntryBody hatena_keyword_link="1"$></p>
    </MTEntries>

フィルタに与えるオプションの値が0もしくは空のときは自動リンクを行いません。それ以外の値が設定されているときには自動リンクを行います。

## 実験的な機能

### エントリー保存時に自動リンク

PHPによるダイナミック・パブリッシングでは、MTHatenaKeywordLinkコンテナやhatena_keyword_linkフィルタが使えません。また、再構築するたびにはてなダイアリーキーワード自動リンクAPIにアクセスするため、速度が犠牲となります。こうした問題に対するad hocな解となる機能を付加してあります。

各ブログのプラグイン設定画面で、「This enables auto-linking by using MT::Entry::pre_save handler.」というチェックボックスをONにすると、エントリーの保存時にはてなダイアリーキーワードへの自動リンクが行われます。この場合には、エントリーの内容(body)と追記(more)が自動的に書き換えられ、データーベースに保存されます。このため、MTHatenaKeywordLinkコンテナやhatena_keyword_linkフィルタによる変換なしにリンク付きテキストを表示することができます。

この動作が望ましくないと思われる場合には、決してチェックボックスをONにしないでください。

## See Also

## License

This code is released under the Artistic License. The terms of the Artistic License are described at [http://www.perl.com/language/misc/Artistic.html]().

## Author & Copyright

Copyright 2006, Hirotaka Ogawa (hirotaka.ogawa at gmail.com)
