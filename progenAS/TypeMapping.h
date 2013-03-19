#pragma once
/**************************************************************
 * (C) Copyright 2013 Alanmars
 * Keep it simple at first 
 *************************************************************/

#include <map>
#include <string>

class TypeMapping
{
	typedef std::map<std::string, std::string> TypeMap;
public:
	~TypeMapping(void);
	static const std::string& getCXXType(const std::string &asType);
	static const std::string& getASType(const std::string &cxxType);
private:
	TypeMapping();
	static TypeMapping& instance();
private:
	TypeMap m_cxxASMap;
	TypeMap m_asCXXMap;
};

