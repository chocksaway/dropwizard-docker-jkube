package com.chocksaway;

import com.chocksaway.controller.RootResource;
import com.chocksaway.filter.DiagnosticContextFilter;
import com.chocksaway.health.DefaultHealthCheck;
import io.dropwizard.setup.Environment;

public class App extends io.dropwizard.Application<AppConfig> {

    public static void main(String[] args) throws Exception {
        new App().run(args);
    }

    @Override
    public void run(AppConfig config, Environment env) {
        env.jersey().register(new RootResource(config.getAppName()));
        env.jersey().register(new DiagnosticContextFilter());
        env.healthChecks().register("default", new DefaultHealthCheck());
    }
}
