#include "TypeMapping.h"


TypeMapping::TypeMapping(void)
{
	m_cxxASMap.insert(std::make_pair(std::string("bool"), std::string("Boolean")));
	m_cxxASMap.insert(std::make_pair(std::string("int8_t"), std::string("int")));
	m_cxxASMap.insert(std::make_pair(std::string("int16_t"), std::string("int")));
	m_cxxASMap.insert(std::make_pair(std::string("int32_t"), std::string("int")));
	m_cxxASMap.insert(std::make_pair(std::string("int64_t"), std::string("Number")));
	m_cxxASMap.insert(std::make_pair(std::string("uint8_t"), std::string("uint")));
	m_cxxASMap.insert(std::make_pair(std::string("uint16_t"), std::string("uint")));
	m_cxxASMap.insert(std::make_pair(std::string("uint32_t"), std::string("uint")));
	m_cxxASMap.insert(std::make_pair(std::string("uint64_t"), std::string("Number")));
	m_cxxASMap.insert(std::make_pair(std::string("std::string"), std::string("String")));
}

TypeMapping::~TypeMapping(void)
{
}

TypeMapping& TypeMapping::instance()
{
	static TypeMapping tm;
	return tm;
}

const std::string& TypeMapping::getCXXType(const std::string &asType)
{
	static std::string stemp;
	return stemp;
}

const std::string& TypeMapping::getASType(const std::string &cxxType)
{
	TypeMap &cxxASMap = instance().m_cxxASMap;
	TypeMap::const_iterator it = cxxASMap.find(cxxType);
	if (it != cxxASMap.end())
		return it->second;
	else
	{
		printf("Unrecognized cxx type, program aborted with exception.\n");
		exit(1);
	}
}
