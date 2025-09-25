package com.vipa.scoring.utils;

import com.qcloud.cos.COSClient;
import com.qcloud.cos.ClientConfig;
import com.qcloud.cos.auth.BasicCOSCredentials;
import com.qcloud.cos.auth.COSCredentials;
import com.qcloud.cos.http.HttpProtocol;
import com.qcloud.cos.model.*;
import com.qcloud.cos.region.Region;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class downloadFromCOS {
    // 创建 COSClient 实例，这个实例用来后续调用请求
    static COSClient createCOSClient() {
        // 设置用户身份信息。
        // SECRETID 和 SECRETKEY 请登录访问管理控制台 https://console.cloud.tencent.com/cam/capi 进行查看和管理
        String secretId = "AKIDNe5HOTYZSLBvU1WzHRTIvQlywhGis3tF";
        String secretKey = "Ij4DTfex584oVFzaCya0DQTKzmRxFKF4";
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);

        // ClientConfig 中包含了后续请求 COS 的客户端设置：
        ClientConfig clientConfig = new ClientConfig();

        // 设置 bucket 的地域
        // COS_REGION 请参见 https://cloud.tencent.com/document/product/436/6224
        clientConfig.setRegion(new Region("ap-hongkong"));

        // 设置请求协议, http 或者 https
        // 5.6.53 及更低的版本，建议设置使用 https 协议
        // 5.6.54 及更高版本，默认使用了 https
        clientConfig.setHttpProtocol(HttpProtocol.https);

        // 以下的设置，是可选的：
        // 设置 socket 读取超时，默认 30s
        clientConfig.setSocketTimeout(30*1000);
        // 设置建立连接超时，默认 30s
        clientConfig.setConnectionTimeout(30*1000);
        // 如果需要的话，设置 http 代理，ip 以及 port
        //clientConfig.setHttpProxyIp("httpProxyIp");
        //clientConfig.setHttpProxyPort(80);

        // 生成 cos 客户端。
        return new COSClient(cred, clientConfig);
    }
    public static void main(String[] args) {
        String bucketName = "vipazoo-1316978609";
        String cosPathPrefix = "1095462560381009920"; // 指定要下载的文件前缀
        String localPathPrefix = "/Users/Lipyu/danceScoringDataset/data"; // 指定下载到本地的路径前缀
        COSClient cosClient = createCOSClient();
        ListObjectsRequest listRequest = new ListObjectsRequest();
        listRequest.setBucketName(bucketName);
        listRequest.setPrefix(cosPathPrefix);
        ObjectListing objectListing = null;
        do {
            try {
                objectListing = cosClient.listObjects(listRequest);
                List<COSObjectSummary> cosObjectSummaries = objectListing.getObjectSummaries();
                List<Thread> threads = new ArrayList<>();
                for (final COSObjectSummary cosObjectSummary : cosObjectSummaries) {
                    Thread thread = new Thread(() -> {
                        String cosPath = cosObjectSummary.getKey();
                        if (cosPath.endsWith("/")) { // 跳过目录
                            return;
                        }
                        File localFileDir = new File(localPathPrefix + "/" + cosPath.substring(cosPathPrefix.length(), cosPath.lastIndexOf("/") + 1));
                        localFileDir.mkdirs();
                        File localFile = new File(localPathPrefix + "/" + cosPath.substring(cosPathPrefix.length()));
                        cosClient.getObject(new GetObjectRequest(bucketName, cosPath), localFile);
                        System.out.println("Downloaded file: " + cosPath);
                    });
                    threads.add(thread);
                    thread.start();
                }
                for (Thread thread : threads) {
                    try {
                        thread.join();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            listRequest.setMarker(objectListing.getNextMarker());
        } while (objectListing.isTruncated());
        cosClient.shutdown();
    }
}