package com.chocksaway;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.dropwizard.Configuration;

import javax.validation.constraints.NotEmpty;


public class AppConfig extends Configuration {
    @JsonProperty
    @NotEmpty
    private String appName = "appName";

    public String getAppName() {
        return appName;
    }
}
