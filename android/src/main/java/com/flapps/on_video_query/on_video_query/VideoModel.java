package com.flapps.on_video_query.on_video_query;

import java.util.HashMap;

public class VideoModel {
    private  String path;
    private  int id;
    private  String name;
    private  int duration;



    public VideoModel(String path, int id, String name,int duration) {
        this.path = path;
        this.id = id;
        this.name = name;
        this.duration=duration;
    }



    public HashMap toMap(){
        HashMap map=new HashMap();
        map.put("path",path);
        map.put("id",id);
        map.put("name",name);
        map.put("duration",duration);
        return  map;
    }

}
