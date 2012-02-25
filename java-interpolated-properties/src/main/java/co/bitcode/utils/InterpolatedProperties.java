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

import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * A Property bag which supports variable interpolation (retrieved within
 * the same property bag).
 *
 * <p>
 * <strong>This class doesn't handle infinite recursion during variable expansion</strong>
 * </p>
 *
 * @author Lorenzo Villani
 */
public class InterpolatedProperties extends Properties {
    private static final Pattern interpolationPattern = Pattern.compile("\\$\\{([\\w\\.]+)\\}");

    @Override
    public String getProperty(String propertyName) {
        String value = super.getProperty(propertyName);

        if (value == null) {
            return null;
        } else {
            Matcher m = interpolationPattern.matcher(value);

            if (m.find()) {
                String replacement = getProperty(m.group(1));

                if (replacement != null) {
                    return m.replaceAll(getProperty(m.group(1)));
                } else {
                    return m.replaceAll("");
                }
            } else {
                return value;
            }
        }
    }

    @Override
    public String getProperty(String propertyName, String defaultValue) {
        String value = getProperty(propertyName);

        if (value == null) {
            return defaultValue;
        } else {
            return value;
        }
    }
}
