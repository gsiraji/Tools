#!/usr/bin/env python
# coding: utf-8

# resize images for faster processing in DL
from PIL import Image as Im
import pandas as pd


def resize_images(data_indices):

    for i in data_indices:

        # read image
        img = Im.open('MLI_all_tiff/{}.tif'.format(i))
        print('read image {}'.format(i))

        width, height = img.size
        img_resize = img.resize((int(width/15),int(height/15)))

        # save resized image
        img_resize.save('MLI_all_tiff/resize/{}.tif'.format(i))




# load lung image tissue data using pandas to get indices
# e.g. pd.read_excel("oldMLI_data.xlsx",index_col = 0), data.index
data = [42,43]

resize_images(data)
