#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#define EXPORT __declspec(dllexport)
/*i'll be very honest 95% of the code i copied online
because i don't know how to use all those windows thing
and im not bothered to learn it*/
int EXPORT registry_key(lua_State *L) {
    HKEY hKey;
    if (RegOpenKeyEx(HKEY_CURRENT_USER, "Environment", 0, KEY_QUERY_VALUE | KEY_SET_VALUE, &hKey) != ERROR_SUCCESS) {
        return 0;
    }

    const char* valueName = lua_tostring(L, 1);
    const char* valueData = lua_tostring(L, 2);

    if (RegSetValueExA(hKey, valueName, 0, REG_SZ, (const BYTE *)valueData, strlen(valueData) + 1) != ERROR_SUCCESS) {
        RegCloseKey(hKey);
        return 0;
    }

    RegCloseKey(hKey);
    return 0;
}


int EXPORT registry_path(lua_State *L) {
    HKEY hKey;
    if (RegOpenKeyEx(HKEY_CURRENT_USER, "Environment", 0, KEY_QUERY_VALUE | KEY_SET_VALUE, &hKey) != ERROR_SUCCESS) {
        printf("Error opening registry key.\n");
        return 1;
    }

    DWORD dwDataSize = 0;
    if (RegGetValueA(hKey, NULL, "Path", RRF_RT_REG_SZ, NULL, NULL, &dwDataSize) != ERROR_SUCCESS) {
        printf("Error retrieving Path value size.\n");
        RegCloseKey(hKey);
        return 1;
    }

    LPBYTE lpData = (LPBYTE)malloc(dwDataSize);
    if (lpData == NULL) {
        printf("Error allocating memory.\n");
        RegCloseKey(hKey);
        return 1;
    }

    if (RegGetValueA(hKey, NULL, "Path", RRF_RT_REG_SZ, NULL, lpData, &dwDataSize) != ERROR_SUCCESS) {
        printf("Error retrieving Path value.\n");
        free(lpData);
        RegCloseKey(hKey);
        return 1;
    }

    LPCSTR lpValueName = lua_tostring(L, 1);
    size_t currentValueSize = strlen(lpData);

    if (currentValueSize > 0 && lpData[currentValueSize - 1] != ';') {
        strcat((char*)lpData, ";");
    }
    strcat((char*)lpData, lpValueName);
    
    if (RegSetValueExA(hKey, "Path", 0, REG_SZ, (const BYTE*)lpData, strlen(lpData) + 1) != ERROR_SUCCESS) {
        printf("Error setting registry value.\n");
    }

    free(lpData);
    RegCloseKey(hKey);

    return 0;
}


const luaL_reg funcs[] = {
  { "registry_path", registry_path },
  { "registry_key", registry_key },
  { NULL, NULL }
};

EXPORT int luaopen_registry(lua_State *L){
    luaL_register(L, "registry", funcs);
    return 1; // Added return statement
}
