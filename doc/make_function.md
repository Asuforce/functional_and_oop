##結局何がすごいの？
* 関数型の関数ってどうなってる
* オブジェクト指向を使う言語と何が違うの

##実際に問題を解く
* 入力として整数の配列あるいはリストが与えられる
* 0から数えてn番目の要素にはnを掛ける
* それらすべてを足し合わせて出力として返す  

		[10,20,30,40,50]を与えたとすると
		10 * 0 + 20 * 1 + 30 * 2 + 40 * 3 + 50 * 4
		A.400

##オブジェクト指向型のおさらい
* 命令を列挙していくスタイル
* 再代入可能な変数が存在する（状態があるという
* 再代入を使い状態を変化させる

##オブジェクト指向型言語の場合(PHP)
    function calculator($array)
    {
        $ret = 0;;
      for ($i=0; $i<count($array); $i++) {
        $ret = $ret + $array[$i] * $i;
       }
      return $ret;
    }

##関数型のおさらい
* 関数を引数に適用する
* 状態はない
* 破壊的代入を行いたくなった場合は新たな値を作る

##関数型言語の場合(Haskell)
* こうなる！

		mul (i,x) = i * x
		calc xs = foldl (+) 0 (map mul (zip [0..] xs))
    
##Haskellは何をしているのか？
* MapReduceという方法が使われている
* map関数とreduceというやり方を組み合わせて使う

###リストをまとめるzip
* zipは二つのリストからタプルのリストを作る

		[10, 20, 30, 40, 50]
		[0..4]
		zip [0..] [10, 20, 30, 40, 50]
		[(0,10),(1,20),(2,30),(3,40),(4,50)]

###mapを使って関数を適用する前に！
* mapは第一引数に関数、第二引数にリストを取る
* 関数を引数に取れる関数は高階関数という
* 関数をリストのそれぞれの値に適用するのがmapの役割
* 今回の問題ではリストのそれぞれの要素にカウンタを掛け合わせること
* 上記の関数を実装すると下記のようになる
		
		mul (i, z) = i * x

###mapを使う
* mapを使ってmulとzipするリストを組み合わせる
		
		map mul (zip [0..] [10, 20, 30, 40, 50])
        	[0,20,60,120,200]

###reduceとは
* reduceはリストの要素を何らかの方法で1つにまとめること
* 上記のことを「畳み込み」という
* 次にやりたいことはリストのそれぞれの値を足すこと
		
		((((0 + 0) + 20) + 60) + 120) + 200
        	400

* 初期値0に対して、要素を順番に足す
* Haskellではfoldlという関数がある

###foldlを使う
* foldlは第一引数に演算子、第二引数に初期値、第三引数にリストを取る
		
		foldl (+) 0 (map mul (zip [0..] [10, 20, 30, 40, 50]))
		400

###ついに関数として定義！
* mulは自作関数なので、最初に定義
* 関数名はcalc、変数xsにはリストが入ります。
		
		mul (i,x) = i * x
		calc xs = foldl (+) 0 (map mul (zip [0..] xs))