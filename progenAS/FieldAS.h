#pragma once
/**************************************************************
 * (C) Copyright 2013 Alanmars
 * Keep it simple at first 
 *************************************************************/

#include "tinyxml2.h"
#include <string>
#include <stdio.h>
#include <stdint.h>

class FieldAS
{
public:
	FieldAS(const tinyxml2::XMLElement *elem);
	~FieldAS(void);
	void write(FILE *destFile, uint32_t tabCount) const;
	const std::string& name() const;
	const std::string& type() const;
	const std::string& attr() const;
private:
	std::string m_name;
	std::string m_type;
	std::string m_attr;
};

