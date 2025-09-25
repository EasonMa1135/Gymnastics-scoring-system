package com.vipa.scoring.controller;

import com.vipa.scoring.entity.EvaluationBean;
import com.vipa.scoring.service.EvaluationService;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sun.misc.BASE64Encoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.TimeZone;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/evals")
public class EvaluationController {
    @Resource
    EvaluationService evalService;
    @Resource
    EvaluationBean evaluationBean;

    @PostMapping("/file")
    public ResponseEntity<Map<String, Object>> uploadFile(@RequestParam("file") MultipartFile file, @RequestParam("user_id") BigInteger user_id, @RequestParam("manual_score") Integer[] manual_score) throws IOException {
        Map<String, Object> resultMap = new HashMap<String, Object>();

        EvaluationBean eval=evalService.getLatestgEvaluation();
        byte[] fileBytes = file.getBytes();
        System.out.println(fileBytes.length);


        ZoneId beijingZoneId = ZoneId.of("Asia/Shanghai");
        TimeZone.setDefault(TimeZone.getTimeZone(beijingZoneId));

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH-mm-ss");

        LocalDateTime currentDateTime = LocalDateTime.now();
        ZonedDateTime beijingDateTime = currentDateTime.atZone(beijingZoneId);

        String formattedDateTime = beijingDateTime.format(formatter);
        //String formattedDateTime = currentDateTime.format(formatter);
        System.out.println("当前时间 ：" + formattedDateTime);



        String orifileName = file.getOriginalFilename();
        String suffixName = orifileName.substring(orifileName.lastIndexOf("."));
        String fileName = user_id+"/"+ formattedDateTime + suffixName;

        String path = fileName;



//        File f = new File(path);
//        FileOutputStream fos = new FileOutputStream(f);
//        fos.write(fileBytes);
//        fos.close();
        //保存到COS数据库上
        String info = evalService.uploadToCOS(fileBytes, path);

        System.out.println(info);
      //  evaluationBean.setEval_path(path);
        //eval.setEval_path(path);
        //测评
        //Integer score = evalService.getEval(f);
        Integer score = 101;
        //return score;
        //eval.setManual_score(manual_score);
        //eval.setAi_score(score);
        resultMap.put("score", score);
        resultMap.put("manual_score", manual_score);

        evalService.uploaditem(user_id,  manual_score, path);

        return new ResponseEntity<Map<String, Object>>(resultMap, HttpStatus.OK);

    }


    @GetMapping("/downloadFile/{eval_id}")
    public byte[] fileDownload(@PathVariable int eval_id) throws IOException {
        EvaluationBean evalbykey = evalService.getEvauationByKey(eval_id);
        String uploadFilePath = evalbykey.getEval_path();

        byte[] bytes = evalService.downloadFromCOS(uploadFilePath);
        return bytes;
    }

    @GetMapping("/video/{eval_id}")
    public ResponseEntity<InputStreamResource> downloadVideo(@PathVariable int eval_id) throws IOException {
        EvaluationBean evalbykey = evalService.getEvauationByKey(eval_id);
        String uploadFilePath = evalbykey.getEval_path();
        File file = new File(uploadFilePath);
        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + file.getName())
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .contentLength(file.length())
                .body(resource);
    }



    @GetMapping("/user_id/{user_id}")
    public List<EvaluationBean> getEvaluationById(@PathVariable Integer user_id)
    {

        List<EvaluationBean> eval=evalService.getEvaluationById(user_id);
        return eval;

    }
    @PostMapping("/evalpageforuser")
    public List<EvaluationBean> getEvaluationPage(
                                                  @RequestParam("user_id") BigInteger user_id,
                                                  @RequestParam(value = "PageSize",required = false,defaultValue = "-1") int PageSize,
                                                  @RequestParam(value = "PageIndex",required = false,defaultValue = "-1") int PageIndex)
    {
        System.out.println(user_id.toString() + " " + PageIndex+ " "+PageSize);
        List<EvaluationBean> eval=evalService.getEvaluationPage(user_id,PageSize,PageIndex);
        System.out.println(eval.size());
        return  eval;
    }

    @GetMapping("/evalNumforuser/{user_id}")
    public Integer getEvaluationNumById( @PathVariable("user_id") BigInteger user_id)
    {
        System.out.println(user_id.toString());
        return  evalService.getEvaluationNumById(user_id);
    }

    @PostMapping("/notevalpage")
    public List<EvaluationBean> getNotEvaluationById( @RequestParam(value = "PageSize",required = false,defaultValue = "-1") int PageSize,
                                                      @RequestParam(value = "PageIndex",required = false,defaultValue = "-1") int PageIndex)
    {
        System.out.println(PageIndex+ " "+PageSize);
        List<EvaluationBean> eval=evalService.getNotEvaluationById(PageSize, PageIndex);
        return eval;
    }

    @GetMapping("/notevalNum")
    public Integer getNotEvaluationById()
    {
        return  evalService.getNotEvaluationNum();
    }

    @PostMapping("/manual_score")
    public void updateScoreById(@RequestParam("score") int[] score, @RequestParam("eval_id") int eval_id){
        System.out.println(score.length);
        System.out.println("update "+eval_id);
        evalService.updateScoreById(score, eval_id);
    }

    public  byte[] readFileToByteArray(String filePath) throws IOException {
        File file = new File(filePath);
        try (InputStream inputStream = new FileInputStream(file)) {
            byte[] byteArray = new byte[(int) file.length()];
            inputStream.read(byteArray);
            return byteArray;
        }
    }

}
