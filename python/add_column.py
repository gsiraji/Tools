#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 28

@author: gess
"""
# create unique indices for the table given that each set has at most 13 subsets
import pandas as pd

table1 = pd.read_excel("oldMLI_data.xlsx")


table1["indx"] = 0

# table1[table1["day"] == 0]["indx"] = table1[table1["day"] == 0]["slide"].map(lambda x: x+1)
table1.loc[table1["day"] == 0,"indx"] = (table1.loc[table1["day"] == 0, "slide"] - 1)*13 + table1.loc[table1["day"] == 0, "subslide"] - 1

table1.loc[table1["day"] != 0,"indx"] = (table1.loc[table1["day"] != 0, "slide"] + 24)*13 + table1.loc[table1["day"] != 0, "subslide"] - 1



print(table1["indx"].describe())

table1.to_excel("oldMLI_data.xlsx")
