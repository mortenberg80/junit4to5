package com.github.tingstad.junit4to5.asserts;

import org.junit.*;

public class StarImportTest {

    @Test
    public void test() {
        Assert.assertTrue(true);
        Assert.assertTrue("message", true);
        Assert.assertFalse(false);
        Assert.assertFalse("message", false);
    }

}
