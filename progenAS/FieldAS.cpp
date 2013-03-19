#include "FieldAS.h"
#include "TabString.h"
#include "TypeMapping.h"

FieldAS::FieldAS(const tinyxml2::XMLElement *elem) : m_name(elem->Attribute("name")), m_type(elem->Attribute("type"))
{
	if (NULL != elem->Attribute("attr"))
		m_attr = elem->Attribute("attr");
}

FieldAS::~FieldAS(void)
{
}

void FieldAS::write(FILE *destFile, uint32_t tabCount) const
{
	fprintf(destFile, "%spublic var %s : %s;\n", TabString::get(tabCount), m_name.c_str(), TypeMapping::getASType(m_type).c_str());
}

const std::string& FieldAS::name() const
{
	return m_name;
}

const std::string& FieldAS::type() const
{
	return m_type;
}

const std::string& FieldAS::attr() const
{
	return m_attr;
}
