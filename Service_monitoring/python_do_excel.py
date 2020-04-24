#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2020/1/5 16:22


"""
数据报表Excel

"""
import xlsxwriter

workbook = xlsxwriter.Workbook('demo1.xlsx')
worksheet = workbook._add_sheet()

worksheet.set_column('A:A',20)
workbook.add_format({'bold':True})
