#pragma once

// Stand-in for the Visual Studio ATL header. This machine's Build Tools
// install has the MSVC compiler but not the ATL component, and
// flutter_secure_storage_windows only needs the CA2W / CW2A conversions.
// Product code is unchanged. Install Microsoft.VisualStudio.Component.VC.ATL
// and this directory can be removed.

#include <windows.h>
#include <stdlib.h>

class CA2W {
 public:
  LPWSTR m_psz;

  explicit CA2W(LPCSTR source) : m_psz(nullptr) {
    if (source == nullptr) {
      m_psz = static_cast<LPWSTR>(malloc(sizeof(wchar_t)));
      if (m_psz != nullptr) {
        m_psz[0] = L'\0';
      }
      return;
    }
    const int length = MultiByteToWideChar(CP_ACP, 0, source, -1, nullptr, 0);
    if (length <= 0) {
      m_psz = static_cast<LPWSTR>(malloc(sizeof(wchar_t)));
      if (m_psz != nullptr) {
        m_psz[0] = L'\0';
      }
      return;
    }
    m_psz = static_cast<LPWSTR>(malloc(sizeof(wchar_t) * static_cast<size_t>(length)));
    if (m_psz != nullptr) {
      MultiByteToWideChar(CP_ACP, 0, source, -1, m_psz, length);
    }
  }

  ~CA2W() { free(m_psz); }

  CA2W(const CA2W&) = delete;
  CA2W& operator=(const CA2W&) = delete;

  operator LPCWSTR() const { return m_psz; }
};

class CW2A {
 public:
  LPSTR m_psz;

  explicit CW2A(LPCWSTR source) : m_psz(nullptr) {
    if (source == nullptr) {
      m_psz = static_cast<LPSTR>(malloc(1));
      if (m_psz != nullptr) {
        m_psz[0] = '\0';
      }
      return;
    }
    const int length = WideCharToMultiByte(CP_ACP, 0, source, -1, nullptr, 0, nullptr, nullptr);
    if (length <= 0) {
      m_psz = static_cast<LPSTR>(malloc(1));
      if (m_psz != nullptr) {
        m_psz[0] = '\0';
      }
      return;
    }
    m_psz = static_cast<LPSTR>(malloc(static_cast<size_t>(length)));
    if (m_psz != nullptr) {
      WideCharToMultiByte(CP_ACP, 0, source, -1, m_psz, length, nullptr, nullptr);
    }
  }

  ~CW2A() { free(m_psz); }

  CW2A(const CW2A&) = delete;
  CW2A& operator=(const CW2A&) = delete;

  operator LPCSTR() const { return m_psz; }
};
