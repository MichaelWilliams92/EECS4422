function camNoise(N)
{
fc2Info();
con = fc2GetContext();
con->numofcams;
num = fc2NumOfCams(con);
con->camindex=0;
con->caminfo;
fc2CameraSpecs(con);
num = to_int(N);
/* loading each frame in this image */
img = NIL;
/* making an array of num elements to store each frame */
arr = make_array(num,nil);
/* camera resolution : 1624 x 1224 */
sum_images = mk_fimg(1224,1624);
/* mean image of all frames */
mean_img = mk_fimg(1224,1624);
/* variance image for all noise */
var_img = mk_fimg(1224,1624);
/* starting frame acquisition */
fc2StartGrab(con);
for(i = 1 ;i <= num ; i++)
{
    img = fc2GrabImgBW(con,img);	   
    arr[i] = img;
};
/* stop frame acquisition */
fc2StopGrab(con);
con = NIL;
for(i = 1 ;i <= num ; i++)
{
    sum_images += arr[i];
};
mean_img = sum_images/num;
for(i = 1 ;i <= num ; i++)
{
    var_img += (arr[i] - mean_img)*(arr[i] - mean_img);
};
var_img = var_img/num;
/*Y = [mean_img,var_img];*/

   gshow(mean_img);
   gshow(var_img);

};
 
