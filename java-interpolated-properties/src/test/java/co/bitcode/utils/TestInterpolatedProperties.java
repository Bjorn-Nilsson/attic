/*
 * InterpolatedProperties - Extends java.util.Properties to support variable interpolation
 * Copyright (C) 2011  Lorenzo Villani
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package co.bitcode.utils;

import org.junit.Test;

import junit.framework.TestCase;

public class TestInterpolatedProperties extends TestCase {
    private InterpolatedProperties ip;

    @Override
    protected void setUp() throws Exception {
        super.setUp();
        ip = new InterpolatedProperties();
    }

    @Test
    public void testNonExistant() {
        assertEquals(null, ip.getProperty("foobar"));
    }

    @Test
    public void testNonExistantDefaultValue() {
        assertEquals("default", ip.getProperty("foobar", "default"));
    }

    @Test
    public void testSimpleVar() {
        ip.put("no_expansion", "var123");

        assertEquals("var123", ip.getProperty("no_expansion"));
    }

    @Test
    public void testExpansion() {
        ip.put("simple", "var123");
        ip.put("expanded", "var_${simple}");

        assertEquals("var_var123", ip.getProperty("expanded"));
    }

    @Test
    public void testRecursiveExpansion() {
        ip.put("simple", "var123");
        ip.put("expanded", "var_${simple}");
        ip.put("recursive", "rec_${expanded}");

        assertEquals("rec_var_var123", ip.getProperty("recursive"));
    }

    @Test
    public void testBogusExpansion() {
        ip.setProperty("test_bogus", "${bogus}");

        assertEquals("", ip.getProperty("test_bogus"));
    }

    @Test
    public void testDottedExpansion() {
        ip.put("dotted.1", "Hello");
        ip.put("dotted.2", "${dotted.1} world!");

        assertEquals("Hello", ip.getProperty("dotted.1"));
        assertEquals("Hello world!", ip.getProperty("dotted.2"));
    }

    @Test
    public void testDelimiterWithoutSigil() {
        ip.put("sigil", "Hello {foobar}");
                
        assertEquals("Hello {foobar}", ip.getProperty("sigil"));
    }

    @Test
    public void testCorruptedVariables() {
        ip.put("corrupted.1", "test ${corrupted");
        ip.put("corrupted.2", "test ${corrupted variable}");

        assertEquals("test ${corrupted", ip.getProperty("corrupted.1"));
        assertEquals("test ${corrupted variable}", ip.getProperty("corrupted.2"));
    }
}
