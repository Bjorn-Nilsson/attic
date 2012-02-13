/*
 * Nanogear - C++ web development framework
 *
 * This library is based on Restlet (R) <http://www.restlet.org> by Noelios Technologies
 * Copyright (C) 2005-2008 by Noelios Technologies <http://www.noelios.com>
 * Restlet is a registered trademark of Noelios Technologies. All other marks and
 * trademarks are property of their respective owners.
 *
 * Copyright (C) 2008-2009 Lorenzo Villani.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "nrequest.h"

NRequest::NRequest(const NMethod& method, const NClientInfo& clientInfo, NRepresentation* body) :
	m_method(method), m_clientInfo(clientInfo), m_representation(body) {}


const NMethod& NRequest::method() const
{
	return m_method;
}

void NRequest::setNMethod(const NMethod& method)
{
	m_method = method;
}

const NClientInfo& NRequest::clientInfo() const
{
	return m_clientInfo;
}

void NRequest::setClientInfo(const NClientInfo& clientInfo)
{
	m_clientInfo = clientInfo;
}

const NRepresentation* NRequest::entity() const
{
	return m_representation;
}

void NRequest::setEntity(NRepresentation* representation)
{
	m_representation = representation;
}

const QString& NRequest::resourceRef() const
{
	return m_resourceRef;
}

void NRequest::setResourceRef(const QString& path)
{
	m_resourceRef = path;
}

void NRequest::setParameters(const QHash<QString, QString>& parameters)
{
	m_parameters = parameters;
}

const QHash<QString, QString>& NRequest::parameters() const
{
	return m_parameters;
}
