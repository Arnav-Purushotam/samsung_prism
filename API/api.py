from flask import Flask, request, jsonify
import werkzeug
import cv2
import os
import json



app = Flask(__name__)

@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST" :
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        print("\nReceived image File name : " + imagefile.filename)
        imagefile.save("./uploadedimages/" + filename)

        folder_link = "D:\dev\projects\Samsung Prism\\New folder\API\\uploadedImages"
        folder_list = os.listdir(folder_link)
        list_of_links = []
        for item in folder_list:
            new_link = os.path.join(folder_link,item)
            list_of_links.append(new_link)
            print(new_link)

        a = detect_walls(list_of_links[0],5)
        print(a)
        print(5)
        
        k = jsonify({
            "message": "Image Uploaded Successfully new tDDIbbdiuWBD",
            "data" : a
            
            
        })
        #size = sys.getsizeof(k)
        #print(size)
        return k





def cloud_points_generator(contours,height):
    
    final_contour_list = []
    for contour in contours:   
        contour_points = []
        for point in contour:
            #print(point[0][0])
            new_base_point = [point[0][0],point[0][1],0]
            #print(new_base_point)
            
            new_top_point = [point[0][0],point[0][1],height]
            #print(new_top_point)
            
            contour_points.append(new_base_point)
            contour_points.append(new_top_point)
        
        
        final_contour_list.append(contour_points)
    return final_contour_list
            
    



def detect_walls(im_link,height):

    im = cv2.imread(im_link)
    img = im.copy()
    imgray = cv2.cvtColor(im,cv2.COLOR_BGR2GRAY)
    ret,thresh = cv2.threshold(imgray,10,255,0)
    contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)

    new_contours = []
    for contour in contours:
        
        area = cv2.contourArea(contour)
        if area > 50:
            new_contours.append(contour)
            
    ff = cloud_points_generator(new_contours, height)
    
    for item in ff:
        for point in item:
            for i in range(len(point)):
                point[i] = int(point[i])
    
    #my_json = json.dumps(ff)
    
    return ff
    
    






if __name__ == "__main__":
    app.run(debug=True, port=9000)



#if __name__ == "__main__":
 #   app.run(host="0.0.0.0")
    