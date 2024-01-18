# riverpodtest

経費精算モックアップ

flutter(riverpod、go_router、freezed)、firebase/firestoreを具体的に使ってみる。
具体化の策として簡易な経費精算アプリを作成する。

デザインについては凝らない。

## 利用コンポーネント

- flutter
- riverpod
- freezed
- firebase
- firestore
- firebase、firestoreエミュレーター


## 画面イメージ
### 経費精算ホーム
ログインした状態。選択可能は『ログアウト』と『レポート一覧』だけ。ログイン前は『ログイン』だけが選択可能になっている。
| <img width="280"  src="docs/経費精算ホーム.png"> |
| ------------------------------------------------ |



### 経費レポート一覧
経費レポート一覧。ステータスは『申請済み』と『作成中』がある。『申請済み』は削除できない。
クリックすると『経費一覧』へ行く。
<img width="280"  src="docs/経費レポート一覧.png">

### 経費一覧
レポートが『作成中』の場合、経費の追加、削除、修正が可能。
『申請済み』の場合は照会だけ。
『経費種別』は『交通費』と『その他』。
<img width="280"  src="docs/経費一覧.png">

### 交通費
- 経費種別
  ドロップダウンで『経費種別』か『交通費』を選択可能。選択により入力項目が切り替わる。
- 税タイプ
  ドロップダウンで『インボイス対象』か『レシート無し対象』を選択可能。選択により入力項目が切り替わる。  
<img width="280"  src="docs/交通費前半.png">
<img width="280"  src="docs/交通費後半.png">

### その他

<img width="280"  src="docs/その他前半.png">
<img width="280"  src="docs/その他後半.png">


## その他
以下の点は課題。
- goRouterでのパラメータ渡し
  画面呼出し時、パラメータをテキストに変換している点が効率的ではない。
- firebase、firestoreでのサーバーステータスの確認
  エミュレータを使っているが、アプリ開始時のサーバー状態確認ができていない。


## ドキュメント
/doc/expences.readme.md