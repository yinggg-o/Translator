package com.yinggg.translator.Config;

@FunctionalInterface
public interface DataFormatValidatorFunction<T> {
    boolean validate(T value);
}
