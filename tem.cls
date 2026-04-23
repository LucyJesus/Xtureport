\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tem}[2026/04/23 XTU LaTeX template class]

% 说明:
% - 本类以 ctexart 为基础, 适合中文论文/实验报告.
% - 这里加载“模板强依赖”的基础宏包, 以减少用户文档重复声明.

% 将所有未知选项转交给基础类
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessOptions\relax

% 基础类: ctex(中文排版)
\LoadClass{ctexart}

% 基础宏包依赖
% 图形
\RequirePackage{graphicx}

% 版式
\RequirePackage{geometry}
\geometry{%
	top=3.2cm,
	bottom=2.5cm,
	left=2.0cm,
	right=2.0cm,
	columnsep=0.78cm,
	headheight=12pt,
	headsep=1.2cm,
	footskip=0pt
}

% 避免为了“齐底”拉伸段间空白, 导致页面中间出现大空行
\raggedbottom

% 字体: 优先使用项目 fonts/ 目录, 否则回退到系统字体
\RequirePackage{iftex}
\newcommand\temSetFontDir[1]{\def\tem@fontdir{#1}}
\temSetFontDir{fonts/}

% 说明:
% - localFile: 放在 \tem@fontdir 下的字体文件名(建议包含扩展名, 如 SimSun.ttf)
% - systemName: 系统中可识别的字体名(如 SimSun)
% - 仅在 XeTeX/LuaTeX 下生效(tectonic 通常为 XeTeX).
\ifXeTeX
	\RequirePackage{fontspec}
	\newcommand\temSetMainFontWithFallback[3][]{%
		\IfFileExists{\tem@fontdir#2}{%
			\setmainfont[#1,Path=\tem@fontdir]{#2}%
		}{%
			\setmainfont[#1]{#3}%
		}%
	}
	\newcommand\temSetSansFontWithFallback[3][]{%
		\IfFileExists{\tem@fontdir#2}{%
			\setsansfont[#1,Path=\tem@fontdir]{#2}%
		}{%
			\setsansfont[#1]{#3}%
		}%
	}
	\newcommand\temSetMonoFontWithFallback[3][]{%
		\IfFileExists{\tem@fontdir#2}{%
			\setmonofont[#1,Path=\tem@fontdir]{#2}%
		}{%
			\setmonofont[#1]{#3}%
		}%
	}
\else\ifLuaTeX
	\RequirePackage{fontspec}
	\newcommand\temSetMainFontWithFallback[3][]{%
		\IfFileExists{\tem@fontdir#2}{%
			\setmainfont[#1,Path=\tem@fontdir]{#2}%
		}{%
			\setmainfont[#1]{#3}%
		}%
	}
	\newcommand\temSetSansFontWithFallback[3][]{%
		\IfFileExists{\tem@fontdir#2}{%
			\setsansfont[#1,Path=\tem@fontdir]{#2}%
		}{%
			\setsansfont[#1]{#3}%
		}%
	}
	\newcommand\temSetMonoFontWithFallback[3][]{%
		\IfFileExists{\tem@fontdir#2}{%
			\setmonofont[#1,Path=\tem@fontdir]{#2}%
		}{%
			\setmonofont[#1]{#3}%
		}%
	}
\else
	% pdfTeX 下没有 fontspec, 这些命令给出清晰报错
	\newcommand\temSetMainFontWithFallback[3][]{%
		\ClassError{tem}{Font fallback requires XeTeX/LuaTeX}{}
	}
	\newcommand\temSetSansFontWithFallback[3][]{%
		\ClassError{tem}{Font fallback requires XeTeX/LuaTeX}{}
	}
	\newcommand\temSetMonoFontWithFallback[3][]{%
		\ClassError{tem}{Font fallback requires XeTeX/LuaTeX}{}
	}
\fi\fi

% 总则: 42 行/页, 每行字数控制
% 说明:
% - 这里用 \ccwd(中文字符宽度)估算“每行字数”. 实际效果会受字体与标点影响.
% - 单栏按 45 字/行设置版心宽度.
% - 双栏按每栏 21 字设置版心宽度(总宽度=2*21*\ccwd+栏间距).
\newcommand\temSetLinesPerPage[1]{\def\tem@linesperpage{#1}}
\newcommand\temSetCharsPerLineOneColumn[1]{\def\tem@charsonecol{#1}}
\newcommand\temSetCharsPerColumnTwoColumn[1]{\def\tem@charstwocol{#1}}
\temSetLinesPerPage{42}
\temSetCharsPerLineOneColumn{45}
\temSetCharsPerColumnTwoColumn{21}

% 页眉: 小五号宋体, 英文 Times New Roman
\RequirePackage{fancyhdr}
\makeatletter
\newdimen\tem@headtabcenter
\newdimen\tem@headtabright
\tem@headtabcenter=8.5cm\relax
\tem@headtabright=16.8cm\relax

\def\tem@headleft{}
\def\tem@headcenter{}
\def\tem@headright{}
\newcommand\temSetHeaderContent[3]{%
	\def\tem@headleft{#1}%
	\def\tem@headcenter{#2}%
	\def\tem@headright{#3}%
}
\newcommand\temSetHeaderTabStops[2]{%
	\tem@headtabcenter=#1\relax
	\tem@headtabright=#2\relax
}

% 字体族: 优先 fonts/ 下的字体文件, 否则使用系统字体名
\ifXeTeX
	\newcommand\temSetupHeaderFonts[4]{%
		% #1 CJK local file, #2 CJK system name, #3 Latin local file, #4 Latin system name
		\ifdefined\newCJKfontfamily
			\IfFileExists{\tem@fontdir#1}{%
				\newCJKfontfamily\tem@HeaderCJK[Path=\tem@fontdir]{#1}%
			}{%
				\IfFontExistsTF{#2}{%
					\newCJKfontfamily\tem@HeaderCJK{#2}%
				}{%
					\let\tem@HeaderCJK\relax
				}%
			}%
		\else
			% 兜底: 如果没有 xeCJK 的字体族接口, 退回到 ctex 默认宋体
			\let\tem@HeaderCJK\relax
		\fi
		\IfFileExists{\tem@fontdir#3}{%
			\newfontfamily\tem@HeaderLatin[Path=\tem@fontdir]{#3}%
		}{%
			\IfFontExistsTF{#4}{%
				\newfontfamily\tem@HeaderLatin{#4}%
			}{%
				\let\tem@HeaderLatin\relax
			}%
		}%
	}
\else\ifLuaTeX
	\newcommand\temSetupHeaderFonts[4]{%
		\ifdefined\newCJKfontfamily
			\IfFileExists{\tem@fontdir#1}{%
				\newCJKfontfamily\tem@HeaderCJK[Path=\tem@fontdir]{#1}%
			}{%
				\IfFontExistsTF{#2}{%
					\newCJKfontfamily\tem@HeaderCJK{#2}%
				}{%
					\let\tem@HeaderCJK\relax
				}%
			}%
		\else
			\let\tem@HeaderCJK\relax
		\fi
		\IfFileExists{\tem@fontdir#3}{%
			\newfontfamily\tem@HeaderLatin[Path=\tem@fontdir]{#3}%
		}{%
			\IfFontExistsTF{#4}{%
				\newfontfamily\tem@HeaderLatin{#4}%
			}{%
				\let\tem@HeaderLatin\relax
			}%
		}%
	}
\else
	\newcommand\temSetupHeaderFonts[4]{}%
\fi\fi

% 默认页眉字体: 宋体 + Times New Roman(若 fonts/ 无文件则走系统字体)
% 提示: 你之后把 Windows 提取的字体放进 fonts/ 后, 只要文件名匹配即可自动启用.
\temSetupHeaderFonts{SimSun.ttf}{SimSun}{Times New Roman.ttf}{Times New Roman}

\newcommand\tem@headerfont{%
	\zihao{-5}% 小五
	\ifdefined\tem@HeaderLatin\tem@HeaderLatin\fi
	\ifdefined\tem@HeaderCJK\tem@HeaderCJK\fi
}

\newcommand\tem@makeheaderline{%
	\begingroup
	\tem@headerfont
	\makebox[0pt][l]{\tem@headleft}%
	\hspace*{\tem@headtabcenter}\makebox[0pt][c]{\tem@headcenter}%
	\hspace*{\dimexpr\tem@headtabright-\tem@headtabcenter\relax}\makebox[0pt][r]{\tem@headright}%
	\endgroup
}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\tem@makeheaderline}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% 进入文档后再计算版心, 保证 baselineskip/\ccwd 已就绪
\AtBeginDocument{%
	\newdimen\tem@textwidth
	\newdimen\tem@textheight

	% 42 行/页
	\tem@textheight=\dimexpr \tem@linesperpage\baselineskip + \topskip\relax

	% 45 字/行(单栏) 或 每栏 21 字(双栏)
	\if@twocolumn
		\tem@textwidth=\dimexpr 2\tem@charstwocol\ccwd + \columnsep\relax
	\else
		\tem@textwidth=\dimexpr \tem@charsonecol\ccwd\relax
	\fi

	\geometry{textwidth=\tem@textwidth,textheight=\tem@textheight}%
}
\makeatother

% 标题块(跨栏): \Zhtitle 后紧跟 \Zhauthor/\Zhaddress/\Entitle/\Enauthor/\Enaddress
% 规范:
% - \Zhtitle: 二号黑体, 英文字体 Arial, 段前 12pt, 居中
% - \Zhauthor: 四号仿宋
% - \Zhaddress: 五号楷体
% - \Entitle: 小四 Times New Roman 加粗
% - \Enauthor: 五号 Times New Roman
% - \Enaddress: 小五 Times New Roman
% 字体来源: 优先 fonts/ 目录的字体文件, 否则回退系统字体名; 都找不到则用 ctex/默认字体, 不报错.
\makeatletter

% --- 字体族辅助: Latin/CJK 优先本地文件, 否则系统字体 ---
\ifXeTeX
	\newcommand\temNewLatinFamilyWithFallback[3]{%
		% #1 control sequence, #2 local file, #3 system name
		\IfFileExists{\tem@fontdir#2}{%
			\newfontfamily#1[Path=\tem@fontdir]{#2}%
		}{%
			\IfFontExistsTF{#3}{%
				\newfontfamily#1{#3}%
			}{%
				\let#1\relax
			}%
		}%
	}
	\newcommand\temNewCJKFamilyWithFallback[3]{%
		% #1 control sequence, #2 local file, #3 system name
		\ifdefined\newCJKfontfamily
			\IfFileExists{\tem@fontdir#2}{%
				\newCJKfontfamily#1[Path=\tem@fontdir]{#2}%
			}{%
				\IfFontExistsTF{#3}{%
					\newCJKfontfamily#1{#3}%
				}{%
					\let#1\relax
				}%
			}%
		\else
			\let#1\relax
		\fi
	}
\else\ifLuaTeX
	\newcommand\temNewLatinFamilyWithFallback[3]{%
		\IfFileExists{\tem@fontdir#2}{%
			\newfontfamily#1[Path=\tem@fontdir]{#2}%
		}{%
			\IfFontExistsTF{#3}{%
				\newfontfamily#1{#3}%
			}{%
				\let#1\relax
			}%
		}%
	}
	\newcommand\temNewCJKFamilyWithFallback[3]{%
		\ifdefined\newCJKfontfamily
			\IfFileExists{\tem@fontdir#2}{%
				\newCJKfontfamily#1[Path=\tem@fontdir]{#2}%
			}{%
				\IfFontExistsTF{#3}{%
					\newCJKfontfamily#1{#3}%
				}{%
					\let#1\relax
				}%
			}%
		\else
			\let#1\relax
		\fi
	}
\else
	\newcommand\temNewLatinFamilyWithFallback[3]{\let#1\relax}
	\newcommand\temNewCJKFamilyWithFallback[3]{\let#1\relax}
\fi\fi

% 预设字体族(找不到就 \relax)
\temNewLatinFamilyWithFallback\tem@ArialLatin{Arial.ttf}{Arial}
\temNewLatinFamilyWithFallback\tem@TimesLatin{Times New Roman.ttf}{Times New Roman}
% Windows 常见文件名: simfang.ttf/simkai.ttf (若你提取后文件名不同, 之后可在这里改)
\temNewCJKFamilyWithFallback\tem@SongCJK{SimSun.ttf}{SimSun}
\temNewCJKFamilyWithFallback\tem@FangSongCJK{simfang.ttf}{FangSong}
\temNewCJKFamilyWithFallback\tem@KaiTiCJK{simkai.ttf}{KaiTi}

% --- 字段存储 ---
\def\tem@Zhtitle{}
\def\tem@Zhauthor{}
\def\tem@Zhaddress{}
\def\tem@Entitle{}
\def\tem@Enauthor{}
\def\tem@Enaddress{}

% 判空工具: 参数为空则执行 #2, 否则执行 #3
\newcommand\tem@ifblank[3]{%
	\if\relax\detokenize{#1}\relax
		#2%
	\else
		#3%
	\fi
}

% 统一接口: 一次性输出“中英文标题/作者/地址”标题块
% 用法: \XtuTitleAuthorAddress{中标题}{中作者}{中文地址}{英标题}{英作者}{英地址}
% 约定: 任一参数为空则忽略该行; 标题块整体单倍行距
\newcommand\tem@titleblockcontentargs[6]{%
	\tem@ifblank{#1#2#3#4#5#6}{}{%
		\par\vspace{12pt}% 段前 12pt
		\begingroup
			\linespread{1}\selectfont
			\centering
			% 中文标题: 二号黑体 + 英文 Arial
			\tem@ifblank{#1}{}{%
				{\zihao{2}\heiti\ifx\tem@ArialLatin\relax\else\tem@ArialLatin\fi #1\par}%
			}%
			% 中文作者: 四号仿宋
			\tem@ifblank{#2}{}{%
				{\zihao{4}\ifx\tem@FangSongCJK\relax\fangsong\else\tem@FangSongCJK\fi #2\par}%
			}%
			% 中文单位/地址: 五号楷体
			\tem@ifblank{#3}{}{%
				{\zihao{5}\ifx\tem@KaiTiCJK\relax\kaishu\else\tem@KaiTiCJK\fi #3\par}%
			}%
			% 英文标题: 小四 Times New Roman 加粗
			\tem@ifblank{#4}{}{%
				{\zihao{-4}\bfseries\ifx\tem@TimesLatin\relax\else\tem@TimesLatin\fi #4\par}%
			}%
			% 英文作者: 五号 Times New Roman
			\tem@ifblank{#5}{}{%
				{\zihao{5}\ifx\tem@TimesLatin\relax\else\tem@TimesLatin\fi #5\par}%
			}%
			% 英文单位/地址: 小五 Times New Roman
			\tem@ifblank{#6}{}{%
				{\zihao{-5}\ifx\tem@TimesLatin\relax\else\tem@TimesLatin\fi #6\par}%
			}%
		\endgroup
		\par\vspace{12pt}% 标题块后留空, 避免正文紧贴
	}%
}

\newcommand\temMakeTitleBlockFromArgs[6]{%
	\if@twocolumn
		\twocolumn[\tem@titleblockcontentargs{#1}{#2}{#3}{#4}{#5}{#6}]%
	\else
		\tem@titleblockcontentargs{#1}{#2}{#3}{#4}{#5}{#6}%
	\fi
}

\newcommand\XtuTitleAuthorAddress[6]{%
	\temMakeTitleBlockFromArgs{#1}{#2}{#3}{#4}{#5}{#6}%
}

\newcommand\Zhtitle[1]{\gdef\tem@Zhtitle{#1}}
\newcommand\Zhauthor[1]{\gdef\tem@Zhauthor{#1}}
\newcommand\Zhaddress[1]{\gdef\tem@Zhaddress{#1}}
\newcommand\Entitle[1]{\gdef\tem@Entitle{#1}}
\newcommand\Enauthor[1]{\gdef\tem@Enauthor{#1}}

% 输出标题块: 旧接口复用新实现
\newcommand\temMakeTitleBlock{%
	\temMakeTitleBlockFromArgs
		{\tem@Zhtitle}{\tem@Zhauthor}{\tem@Zhaddress}{\tem@Entitle}{\tem@Enauthor}{\tem@Enaddress}%
}

% 最后一个命令调用时自动输出标题块
\newcommand\Enaddress[1]{%
	\gdef\tem@Enaddress{#1}%
	\temMakeTitleBlock
}

% 兼容传统 \maketitle: 若使用了本模板字段则输出标题块, 否则退回只打印 \@title
\newcommand\tem@fallbackPrintSimpleTitle{%
	\par\vspace{12pt}%
	\noindent
	\begingroup\centering{\zihao{2}\heiti \@title\par}\endgroup
	\par\vspace{12pt}%
}
\renewcommand\maketitle{%
	\ifx\tem@Zhtitle\@empty
		\tem@fallbackPrintSimpleTitle
	\else
		\temMakeTitleBlock
	\fi
}

% \makeatother

% 摘要/关键词
% 约定:
% - 小五字号按 9pt 处理, 行距固定 14pt
% - 英文使用 Times New Roman; 中文使用宋体
% - 关键词段首空 6pt
\newcommand\tem@EnSmallFiveFont{%
	\fontsize{9}{14}\selectfont
	\ifx\tem@TimesLatin\relax\else\tem@TimesLatin\fi
}
\newcommand\tem@ZhSmallFiveFont{%
	\fontsize{9}{14}\selectfont
	\ifx\tem@SongCJK\relax\songti\else\tem@SongCJK\fi
}

\newcommand\Enabstract[1]{%
	\par
	\begingroup
		\tem@EnSmallFiveFont
		\noindent\textbf{ABSTRACT:}~#1\par
	\endgroup
}

\newcommand\Enkeyword[1]{%
	\par
	\begingroup
		\tem@EnSmallFiveFont
		\noindent\textbf{KEY WORDS:}~#1\par
	\endgroup
}
% \hspace*{6pt}看着怪可以删掉,放在\noindent和\textbf之间.

\newcommand\Zhabstract[1]{%
	\par
	\begingroup
		\tem@ZhSmallFiveFont
		\noindent\textbf{摘要:}#1\par
	\endgroup
}

\newcommand\Zhkeyword[1]{%
	\par
	\begingroup
		\tem@ZhSmallFiveFont
		\noindent\textbf{关键词:}#1\par
	\endgroup
}

% 算法(如需其他算法样式, 后续可在此扩展)
\RequirePackage{algorithm}

% 代码
\RequirePackage{xcolor}
\RequirePackage{listings}

% 这里先不强行定义 listings 风格, 避免与用户/学校规范冲突.

\makeatother
\endinput
