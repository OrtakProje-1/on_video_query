package com.flapps.on_video_query.on_video_query;

import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class Utility {
    public static HashMap<String,List<HashMap>> getAllVideos(Context context) {
        HashMap<String, List<HashMap>> listHashMap=new HashMap<>();

        String[] projection = { MediaStore.Video.VideoColumns.DATA ,MediaStore.Video.Media.DISPLAY_NAME,MediaStore.Video.Media._ID,MediaStore.Video.Media.DURATION};
        Cursor cursor = context.getContentResolver().query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, projection, null, null, null);
        try {
            cursor.moveToFirst();
            do{
                if(cursor.getString(1)==null)continue;
                int columnIndex = cursor
                        .getColumnIndexOrThrow(MediaStore.Video.Media._ID);
                int id = cursor.getInt(columnIndex);
                //Bitmap bitmap= MediaStore.Video.Thumbnails.getThumbnail(getContentResolver(),id,MediaStore.Video.Thumbnails.MICRO_KIND,null);
                String path= cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA));

                String[] divide=path.split("/");
                String foldername=divide[divide.length-2];

                VideoModel videoModel=new VideoModel(path,id,cursor.getString(1),cursor.getInt(3));
                if(listHashMap.containsKey(foldername)){
                    listHashMap.get(foldername).add(videoModel.toMap());
                }
                else {
                    ArrayList<HashMap> modelArrayList=new ArrayList<>();
                    modelArrayList.add(videoModel.toMap());
                    listHashMap.put(foldername,modelArrayList);
                }

            }while(cursor.moveToNext());
            cursor.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return listHashMap;
    }
}
