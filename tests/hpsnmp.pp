include snmp
include psp
#include psp::hpsnmp
class { 'psp::hpsnmp': cmalocalhostrwcommstr => 'SomeSecureString', }
include psp::hphealth
