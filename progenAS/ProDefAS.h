#pragma once
/**************************************************************
 * (C) Copyright 2013 Alanmars
 * Keep it simple at first 
 *************************************************************/

#include "FieldAS.h"
#include <vector>
#include <stdint.h>

class ProDefAS
{
	typedef std::vector<FieldAS> FieldList;
public:
	ProDefAS(const tinyxml2::XMLElement *proElem);
	~ProDefAS(void);
	void write(const std::string &dirPath, uint32_t tabCount) const;
	const std::string& name() const;
private:
	void writeFields(FILE *destFile, uint32_t tabCount) const;
	void writeMethods(FILE *destFile, uint32_t tabCount) const;
private:
	std::string m_name;
	uint32_t m_type;
	FieldList m_fields;
};

