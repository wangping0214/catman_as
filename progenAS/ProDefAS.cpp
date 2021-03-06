#include "ProDefAS.h"
#include "TabString.h"
#include "Toolkit.h"
#include <assert.h>
#include <algorithm>
#include <iterator>

ProDefAS::ProDefAS(const tinyxml2::XMLElement *proElem) : m_name(proElem->Attribute("name"))
{
	m_type = atoi(proElem->Attribute("type"));
	for (const tinyxml2::XMLElement *fieldElem = proElem->FirstChildElement(); NULL != fieldElem; fieldElem = fieldElem->NextSiblingElement())
		m_fields.push_back(FieldAS(fieldElem));
}

ProDefAS::~ProDefAS(void)
{
}

void ProDefAS::write(const std::string &dirPath, const std::string &ns, uint32_t tabCount) const
{
	std::string filePath(dirPath);
	if (!filePath.empty())
	{
		if (filePath.find_last_of('/') != (filePath.size() - 1))
			filePath += '/';
	}
	filePath += ns;
	Toolkit::StringReplace(filePath, ".", "/");
	if (!Toolkit::MakePath(filePath))
	{
		printf("Failed to make path: %s\n", filePath.c_str());
		return;
	}
	//
	filePath += "/" + m_name + ".as";
	FILE *destFile = fopen(filePath.c_str(), "w+");
	assert(NULL != destFile);
	fprintf(destFile, "%spackage %s\n", TabString::get(tabCount), ns.c_str());
	fprintf(destFile, "%s{\n", TabString::get(tabCount));
	fprintf(destFile, "%simport catman.common.OctetsStream;\n", TabString::get(tabCount + 1));
	fprintf(destFile, "%simport catman.net.Protocol;\n", TabString::get(tabCount + 1));
	fprintf(destFile, "%simport flash.events.Event;\n", TabString::get(tabCount + 1));
	fprintf(destFile, "\n");
	fprintf(destFile, "%spublic class %s extends Protocol\n", TabString::get(tabCount + 1), m_name.c_str());
	fprintf(destFile, "%s{\n", TabString::get(tabCount + 1));
	writeFields(destFile, tabCount + 2);
	fprintf(destFile, "\n");
	writeMethods(destFile, tabCount + 2);
	fprintf(destFile, "%s}\n", TabString::get(tabCount + 1));
	fprintf(destFile, "%s}\n", TabString::get(tabCount));
}

void ProDefAS::writeFields(FILE *destFile, uint32_t tabCount) const
{
	for (FieldList::const_iterator it = m_fields.begin(), ie = m_fields.end(); it != ie; ++ it)
		it->write(destFile, tabCount);
}

void ProDefAS::writeMethods(FILE *destFile, uint32_t tabCount) const
{
	std::string upperName;
	std::transform(m_name.begin(), m_name.end(), std::back_inserter(upperName), toupper);

	// constructor
	fprintf(destFile, "%spublic function %s()\n", TabString::get(tabCount), m_name.c_str());
	fprintf(destFile, "%s{\n", TabString::get(tabCount));
	fprintf(destFile, "%ssuper(%u, ProtocolTypes.%s);\n", TabString::get(tabCount + 1), m_type, upperName.c_str());
	fprintf(destFile, "%s}\n", TabString::get(tabCount));
	fprintf(destFile, "\n");

	// clone method
	fprintf(destFile, "%spublic override function clone() : Event\n", TabString::get(tabCount));
	fprintf(destFile, "%s{\n", TabString::get(tabCount));
	fprintf(destFile, "%svar dup : %s = new %s();\n", TabString::get(tabCount + 1), m_name.c_str(), m_name.c_str());
	for (FieldList::const_iterator it = m_fields.begin(), ie = m_fields.end(); it != ie; ++ it)
		fprintf(destFile, "%s dup.%s = %s;\n", TabString::get(tabCount + 1), it->name().c_str(), it->name().c_str());
	fprintf(destFile, "%sreturn dup;\n", TabString::get(tabCount + 1));
	fprintf(destFile, "%s}\n", TabString::get(tabCount));
	fprintf(destFile, "\n");

	// tostring method
	fprintf(destFile, "%spublic override function toString() : String\n", TabString::get(tabCount));
	fprintf(destFile, "%s{\n", TabString::get(tabCount));
	std::string paramList("\"AlarmEvent\", \"type\", \"bubbles\", \"cancelable\", \"eventPhase\", \"m_id\"");
	for (FieldList::const_iterator it = m_fields.begin(), ie = m_fields.end(); it != ie; ++ it)
		paramList += ", \"" + it->name() + "\"";
	fprintf(destFile, "%sreturn formatToString(%s);\n", TabString::get(tabCount + 1), paramList.c_str());
	fprintf(destFile, "%s}\n", TabString::get(tabCount));
	fprintf(destFile, "\n");

	// marshal method
	fprintf(destFile, "%spublic override function marshal(stream : OctetsStream) : OctetsStream\n", TabString::get(tabCount));
	fprintf(destFile, "%s{\n", TabString::get(tabCount));
	for (FieldList::const_iterator it = m_fields.begin(), ie = m_fields.end(); it != ie; ++ it)
	{
		if (it->type() != "std::string")
			fprintf(destFile, "%sstream.marshal_%s(%s);\n", TabString::get(tabCount + 1), it->type().c_str(), it->name().c_str());
		else	// std::string -> String
			fprintf(destFile, "%sstream.marshal_string(%s);\n", TabString::get(tabCount + 1), it->name().c_str());
	}
	fprintf(destFile, "%sreturn stream;\n", TabString::get(tabCount + 1));
	fprintf(destFile, "%s}\n", TabString::get(tabCount));
	fprintf(destFile, "\n");

	// unmarshal method
	fprintf(destFile, "%spublic override function unmarshal(stream : OctetsStream) : OctetsStream\n", TabString::get(tabCount));
	fprintf(destFile, "%s{\n", TabString::get(tabCount));
	for (FieldList::const_iterator it = m_fields.begin(), ie = m_fields.end(); it != ie; ++ it)
	{
		if (it->type() != "std::string")
			fprintf(destFile, "%s%s = stream.unmarshal_%s();\n", TabString::get(tabCount + 1), it->name().c_str(), it->type().c_str());
		else	// std::string -> String
			fprintf(destFile, "%s%s = stream.unmarshal_string();\n", TabString::get(tabCount + 1), it->name().c_str());
	}
	fprintf(destFile, "%sreturn stream;\n", TabString::get(tabCount + 1));
	fprintf(destFile, "%s}\n", TabString::get(tabCount));
}

const std::string& ProDefAS::name() const
{
	return m_name;
}
