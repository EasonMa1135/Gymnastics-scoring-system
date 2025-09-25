package com.vipa.scoring.service;
import java.io.*;
import java.math.BigInteger;
import java.net.URLDecoder;
import java.util.List;


import com.qcloud.cos.model.*;
import com.alibaba.fastjson.JSON;
import com.qcloud.cos.COSClient;
import com.qcloud.cos.ClientConfig;
import com.qcloud.cos.auth.BasicCOSCredentials;
import com.qcloud.cos.auth.COSCredentials;
import com.qcloud.cos.http.HttpProtocol;
import com.qcloud.cos.region.Region;
import com.qcloud.cos.utils.IOUtils;
import com.vipa.scoring.entity.EvaluationBean;
import com.vipa.scoring.mapper.EvaluationMapper;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
public class EvaluationService {
    @javax.annotation.Resource
    private EvaluationMapper evaluationMapper;

    public String uploadToCOS(byte[] contentBytes,String path){
        // 1 初始化用户身份信息（secretId, secretKey）。
        // SECRETID和SECRETKEY请登录访问管理控制台 https://console.cloud.tencent.com/cam/capi 进行查看和管理
        String secretId = "AKIDNe5HOTYZSLBvU1WzHRTIvQlywhGis3tF";
        String secretKey = "Ij4DTfex584oVFzaCya0DQTKzmRxFKF4";
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);
        // 2 设置 bucket 的地域, COS 地域的简称请参照 https://cloud.tencent.com/document/product/436/6224
        // clientConfig 中包含了设置 region, https(默认 http), 超时, 代理等 set 方法, 使用可参见源码或者常见问题 Java SDK 部分。
        Region region = new Region("ap-hongkong");
        ClientConfig clientConfig = new ClientConfig(region);
        // 这里建议设置使用 https 协议
        // 从 5.6.54 版本开始，默认使用了 https
        clientConfig.setHttpProtocol(HttpProtocol.https);
        // 3 生成 cos 客户端。
        COSClient cosClient = new COSClient(cred, clientConfig);

        try{
            //先将字节数组保存成本地文件，再上传到COS
//            // 指定要上传的文件
//            File localFile = new File("/Users/Lipyu/Desktop/VIPA/人体姿态估计/舞蹈评分/80分.mp4");
//            // 指定文件将要存放的存储桶
//            String bucketName = "dance-scoring-1317617847";
//            // 指定文件上传到 COS 上的路径，即对象键。例如对象键为folder/picture.jpg，则表示将文件 picture.jpg 上传到 folder 路径下
//            String key = "80.mp4";
//            PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
//            PutObjectResult putObjectResult = cosClient.putObject(putObjectRequest);
//            System.out.println(JSON.toJSONString(putObjectResult));

            // 直接上传字节数组到COS
            InputStream contentStream = new ByteArrayInputStream(contentBytes);
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(contentBytes.length);
            PutObjectRequest request = new PutObjectRequest("vipazoo-1316978609", path, contentStream, metadata);
            PutObjectResult result = cosClient.putObject(request);
            return JSON.toJSONString(result);
        } catch (Exception clientException) {
            clientException.printStackTrace();
            return clientException.getMessage();
        }
    }

    public byte[] downloadFromCOS(String key) throws IOException {
        // 1 初始化用户身份信息（secretId, secretKey）。
        // SECRETID和SECRETKEY请登录访问管理控制台 https://console.cloud.tencent.com/cam/capi 进行查看和管理
        String secretId = "AKIDNe5HOTYZSLBvU1WzHRTIvQlywhGis3tF";
        String secretKey = "Ij4DTfex584oVFzaCya0DQTKzmRxFKF4";
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);
        // 2 设置 bucket 的地域, COS 地域的简称请参照 https://cloud.tencent.com/document/product/436/6224
        // clientConfig 中包含了设置 region, https(默认 http), 超时, 代理等 set 方法, 使用可参见源码或者常见问题 Java SDK 部分。
        Region region = new Region("ap-hongkong");
        ClientConfig clientConfig = new ClientConfig(region);
        // 这里建议设置使用 https 协议
        // 从 5.6.54 版本开始，默认使用了 https
        clientConfig.setHttpProtocol(HttpProtocol.https);
        // 3 生成 cos 客户端。
        COSClient cosClient = new COSClient(cred, clientConfig);

        key = URLDecoder.decode(key, "UTF-8"); // 对key进行URL解码
        GetObjectRequest getObjectRequest = new GetObjectRequest("vipazoo-1316978609", key);
        COSObject cosObject = cosClient.getObject(getObjectRequest);
        byte[] fileBytes = IOUtils.toByteArray(cosObject.getObjectContent());
//关闭COS客户端
        cosClient.shutdown();
        return fileBytes;
    }


    public Integer getEval(File file){
//        String path = "/Users/Lipyu/Desktop/myGit/DanceScoring/DanceScoringBackend/src/main/resources/100_cut.mp4";
//        File tempFile = new File(path);
        // 构建请求体
        MultiValueMap<String, Object> requestBody = new LinkedMultiValueMap<>();
        Resource videoResource = new FileSystemResource(file) {
            @Override
            public String getFilename() {
                return file.getName();
            }
        };
       // System.out.println("111");
        System.out.println(videoResource.getFilename());
        requestBody.add("video", videoResource);
        requestBody.add("text", "这是一段文本信息");

        // 构建请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        // 发送 POST 请求
        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);
        ResponseEntity<Integer> response = restTemplate.postForEntity("http://10.214.211.208:5000/predict", requestEntity, Integer.class);
        System.out.println(response.getBody());
        return response.getBody();
    }
    public List<EvaluationBean> getEvaluationById(Integer user_id) {return evaluationMapper.getEvaluationById(user_id);}

    public List<EvaluationBean> getEvaluationPage(BigInteger user_id, Integer PageSize, Integer PageIndex) {return evaluationMapper.getEvaluationPage(user_id,PageSize,PageIndex);}

    public List<EvaluationBean> getNotEvaluationById(Integer PageSize, Integer PageIndex){return evaluationMapper.getNotEvaluationById(PageSize, PageIndex);}

    public void uploaditem(BigInteger user_id,  Integer[] manual_score, String path){evaluationMapper.uploaditem(user_id, manual_score, path);}

    public EvaluationBean getLatestgEvaluation(){return evaluationMapper.getLatestgEvaluation();}

    public EvaluationBean getEvauationByKey(Integer eval_id){return evaluationMapper.getEvauationByKey(eval_id);}

    public Integer getNotEvaluationNum() { return evaluationMapper.getNotEvaluationNum();}

    public Integer getEvaluationNumById(BigInteger userId) {return evaluationMapper.getEvaluationNumById(userId);}

    public void updateScoreById(int[] manualScore, int evalId) {
        evaluationMapper.updateScoreById(manualScore, evalId);
    }
}