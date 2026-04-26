# 傻逼学校喜欢用你老母的word文档

为了不花费宝贵的时间调整word的逆天格式,特此编写这个tex模版,文件夹内word文件即为要求.

***本人能力有限,关于英文以及中文之间,全角半角符号的使用,请自行检查.***

## 运行
(此处仅Unix-like系统)
```
bash
./src/tectonic-linux.sh ./main.tex
```
如果需要添加日志,则加上参数 `--keep-logs`。


说明: 这里使用的是官方 Tectonic 0.16.9 发行包. Linux 用 `tectonic-0.16.9-x86_64-unknown-linux-gnu.tar.gz`, Windows 用 `tectonic-0.16.9-x86_64-pc-windows-msvc.zip`。

## 表格用法(Xtutable)

在 [main.tex](main.tex) 中:

```tex
\usepackage{Xtutable}
```

命令: `\XtuTableCaptionRef{tab:perf}{中文表题}{English caption}`
该命令会自动递增表格编号(使用 table 计数器, 不与公式/图片编号冲突), 并写入 label。
正文引用: `表\ref{tab:perf}`。

5. 分组行示例(DFT/DPMA 与数据同行)

```tex
\begin{tabular}{L S S S S}
	oprule
算法 & \multicolumn{1}{c}{\XtuUnitHeader{f_{sp}}{\mathrm{Hz}}} & \multicolumn{1}{c}{\XtuUnitHeader{e_{ang}}{(^\circ)}} & \multicolumn{1}{c}{\XtuUnitHeader{e_{mag}}{\%}} & \multicolumn{1}{c}{\XtuUnitHeader{e_{TVE}}{\%}} \\
\midrule
\multirow{3}{*}{\centering DFT} & 2 & 0.099\,7 & 2.195\,9 & 9.971\,6 \\
& 3 & 0.148\,6 & 3.694\,5 & 14.863\,3 \\
& 4 & 0.194\,3 & 5.553\,8 & 19.521\,4 \\
\addlinespace
\multirow{3}{*}{\centering DPMA} & 2 & 0.007\,3 & 1.241\,0 & 1.238\,1 \\
& 3 & 0.017\,3 & 2.771\,7 & 2.775\,1 \\
& 4 & 0.031\,5 & 4.884\,2 & 4.906\,5 \\
\bottomrule
\end{tabular}
```

## 图片用法(Xtugraph)

在 [main.tex](main.tex) 中:

```tex
\usepackage{Xtugraph}
```

图片命令会自动编号并可引用(使用 figure 计数器, 与表/公式不冲突), 图片文件优先按你给的路径读取, 若找不到会自动尝试 `imgs/文件名`。
单图：\Onegraph[fig:one]{a.png}{中文图题}{English caption}
双图：\Twograph[fig:two]{a.png}{b.png}{中文图题}{English caption}[(a),(b)]
三图：\Threegraph[fig:three]{a.png}{b.png}{c.png}{中文图题}{English caption}[(a),(b),(c)]
四图：\Fourgraph[fig:four]{a.png}{b.png}{c.png}{d.png}{中文图题}{English caption}[(a),(b),(c),(d)]
五图：\Fivegraph[fig:five]{a.png}{b.png}{c.png}{d.png}{e.png}{中文图题}{English caption}[(a),(b),(c),(d),(e)]


说明:

- 多图命令(2~5图)可不写子图标题, 但如果只写 1 个子图标题会报错。
- 正文引用示例: `见图\ref{fig:three}`。

## 杂项
- 写定义,定理,引理,公理,证明,引理,使用`\Def{},\Thm{},\Axiom{},\Proof{},\lithem{}`
- 写数字,使用`\XtuNum{123456.987654}`


## 注
- 做图片的陈列时,不得不花费大精力和LaTeX的浮点精度机制斗智斗勇,不得不承认以作者的水平,无法保证图片所放即所得,因此建议在编译后检查图片位置,如果不满意,可以通过调整图片命令的可选参数来微调位置,甚至通过多写点文字的方法改变.
- 关于封面页,由于学校给出模版没有严格位置参数要求,因此可能需要花时间"反破译"来调整位置,如果急用这个模版,一个可行的方法是照常完成文章其余内容,如何手动在word模版输入封面页的信息,将word保存为pdf,然后将文件保存至同一目录,使用tex的pdfpages包将封面页插入到tex生成的pdf的第一页, 这样就不需要调整tex模版了。