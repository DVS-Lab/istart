from PIL import Image 
import PIL 
import glob


def resizer(image_path):
        return Image.open(image_path).resize((560,857))



img = resizer('pictureFolder/dim-test/A_D_001.jpg') 

img.save('img1.jpg')

#image = Image.open('pictureFolder/dim-test/A_D_001.jpg')


