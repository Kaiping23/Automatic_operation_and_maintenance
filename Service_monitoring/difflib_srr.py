#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2019/12/16 17:20
# 两个字符串差异对比

import difflib

text1 = """text1:   # 定义字符串1
This module provides classes and functions for comparing sequences.
incliding HTML and context and unified diffs.
difflib document v7.4
add string
"""
text1_lines = text1.splitlines()
text2 = """text2:   # 定义字符串2
This module provides classes and functions for Comparing sequences.
incliding HTML and context and unified diffs.
difflib document v7.5"""

text2_lines = text2.splitlines()
d = difflib.Differ()
diff = d.compare(text1_lines, text2_lines)
# print("\n".join(list(diff)))

d_html = difflib.HtmlDiff()
diff_html = d_html.make_file(text1_lines, text2_lines)
print(diff_html)

f = open(r'diff.html', 'w')
print(diff_html, file=f)
f.close()
