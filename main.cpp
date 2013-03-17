#include <stdio.h>
#include <WinSock2.h>
#include <stdint.h>

void sockClient()
{
	SOCKET connSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (connSock == INVALID_SOCKET)
	{
		printf("Error at socket() : %ld\n", WSAGetLastError());
		WSACleanup();
		return;
	}
	sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("192.168.0.102");
	addr.sin_port = htons(50000);

	if (connect(connSock, (SOCKADDR*)(&addr), sizeof(addr)) == SOCKET_ERROR)
	{
		printf("Failed to connect.\n");
		WSACleanup();
		return;
	}
	printf("Connected to server.\n");

	char buff[128];
	char *ptr = buff;
	uint32_t type = 1;
	memcpy(ptr, &type, sizeof(type));
	ptr += sizeof(type);

	char *userName = "Alanmars";
	char *password = "wp2008212555";

	uint32_t size = strlen(userName);
	memcpy(ptr, &size, sizeof(size));
	ptr += sizeof(size);
	strcpy(ptr, userName);
	ptr += size;

	size = strlen(password);
	memcpy(ptr, &size, sizeof(size));
	ptr += sizeof(size);
	strcpy(ptr, password);
	ptr += size;

	int sendSize = send(connSock, buff, ptr - buff, 0);

	char recvBuff[128];
	int recvBytes = recv(connSock, recvBuff, sizeof(recvBuff), 0);
	char *recvPtr = recvBuff;
	if (recvBytes > 0)
	{
		uint32_t recvType = *(uint32_t*)recvPtr;
		recvPtr += sizeof(uint32_t);
		uint32_t recvStrSize = *(uint32_t*)recvPtr;
		recvPtr += sizeof(uint32_t);

		*(recvPtr + recvStrSize) = 0;
		printf("Recv %u, %u, %s\n", recvType, recvStrSize, recvPtr);
	}
}

void sockServer()
{
	SOCKET ListenSocket;
	ListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (ListenSocket == INVALID_SOCKET)
	{
		printf("Error at socket(): %ld\n", WSAGetLastError());
		WSACleanup();
		return;
	}

	//----------------------
	// The sockaddr_in structure specifies the address family,
	// IP address, and port for the socket that is being bound.
	sockaddr_in service;
	service.sin_family = AF_INET;
	service.sin_addr.s_addr = inet_addr("127.0.0.1");
	service.sin_port = htons(5000);

	if (bind( ListenSocket, 
		(SOCKADDR*) &service, 
		sizeof(service)) == SOCKET_ERROR) 
	{
			printf("bind() failed.\n");
			closesocket(ListenSocket);
			return;
	}

	//----------------------
	// Listen for incoming connection requests.
	// on the created socket
	if (listen( ListenSocket, 1 ) == SOCKET_ERROR)
		printf("Error listening on socket.\n");

	//----------------------
	// Create a SOCKET for accepting incoming requests.
	SOCKET AcceptSocket;
	printf("Waiting for client to connect...\n");

	//----------------------
	// Accept the connection.
	char buff[128];
	while(1) 
	{
		AcceptSocket = SOCKET_ERROR;
		while( AcceptSocket == SOCKET_ERROR ) 
		{
			AcceptSocket = accept( ListenSocket, NULL, NULL );
		}
		printf("Client connected.\n");
		//int recvBytes = recv(AcceptSocket, buff, 128, 0);
		//printf("Recv size=%d\n", recvBytes);
		//Sleep(10000);
		int sendBytes = send(AcceptSocket, buff, 128, 0);
		printf("Send size=%d\n", sendBytes);
		//ListenSocket = AcceptSocket;
		//break;
	}
}

int main(int argc, char *argv)
{
	WSADATA wsaData;
	int ires = WSAStartup(MAKEWORD(2, 2), &wsaData);
	if (ires != NO_ERROR)
		printf("Error at WSAStartup()\n");
	
	sockServer();

	WSACleanup();
	return 0;
}