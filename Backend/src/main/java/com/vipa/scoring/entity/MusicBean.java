package com.vipa.scoring.entity;

import lombok.Data;

import java.math.BigInteger;

@Data
public class MusicBean {
    public Integer id;
    private String name;
    private String author;
    private String category;
    private String path;
    private BigInteger views;
}
