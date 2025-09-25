package com.vipa.scoring.controller;

import com.vipa.scoring.entity.MusicBean;
import com.vipa.scoring.mapper.MusicMapper;
import com.vipa.scoring.service.MusicService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.apache.commons.logging.Log;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sun.misc.BASE64Encoder;

import javax.annotation.Resource;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/music")
public class MusicController {
    @Resource
    MusicService musicService;
    Log log;

    @GetMapping
    public  String  hello(){
        return "hello music";
    }

    @GetMapping("/name/{name}")
    public List<MusicBean> getByName(@PathVariable String name){
        BASE64Encoder encoder = new BASE64Encoder();
        List<MusicBean> mu = musicService.getMusicByName(name);
        return mu;
    }

    @GetMapping("/id/{id}")
    public MusicBean getById(@PathVariable String id){
        MusicBean mu = musicService.getMusicById(id);
        return mu;
    }

    @GetMapping( "/file/{id}")
    public byte[] getFilePath(@PathVariable String id)
    {
        try{
            MusicBean mu = musicService.getMusicById(id);
            return getBytes(mu);
        }catch(Exception e){
            System.out.println("No such Music by id: "+ id);
            return new byte[0];
        }
    }

    @PostMapping ( "/file")
    public ResponseEntity<Map<String, Object>> uploadFile( @RequestParam("file") MultipartFile file,
                                                              @RequestParam("user_id") BigInteger userId,
                                                              @RequestParam("manual_score") Integer manualScore) throws IOException {
        byte[] fileBytes = file.getBytes();
        // 处理文件数据...
        System.out.println(fileBytes[3]);
        File f = new File("video.mp4");
        FileOutputStream fos = new FileOutputStream(f);
        fos.write(fileBytes);
        fos.close();
        Map<String, Object> response = new HashMap<String, Object>();
        System.out.println(userId);
        System.out.println( manualScore);
        // 将要返回的数据添加到Map中
        response.put("score",  90);
        response.put("manual_score", manualScore);

        // 设置状态码为200 OK
        return new ResponseEntity<Map<String, Object>>(response, HttpStatus.OK);
    }


    @GetMapping("/category/{category}")
    public List<MusicBean> getByCategory(@PathVariable String category,
                                         @RequestParam(value = "pageNum", required = false, defaultValue = "-1") int PageNum,
                                         @RequestParam(value = "pageSize", required = false, defaultValue = "-1") int PageSize)
    {
        System.out.println(PageNum);
        List<MusicBean> mu = musicService.getMusicByCategory(category);
        return mu;
    }



    private byte[] getBytes(MusicBean mu) {
        if(mu!=null){
            System.out.println("Load music from "+mu.getPath());
            try{
                File f = new File(mu.getPath());
                byte[] mf = Files.readAllBytes(f.toPath());
                return mf;
            }catch (IOException e){
                return new byte[1];
            }
        }
        else{
            return new byte[1];
        }
    }

}
