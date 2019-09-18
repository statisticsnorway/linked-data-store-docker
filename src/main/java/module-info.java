import no.ssb.rawdata.api.RawdataClientInitializer;

module no.ssb.lds.server {
    requires no.ssb.lds.core;
    requires no.ssb.config;
    requires org.slf4j;
    requires no.ssb.rawdata.api;
    requires no.ssb.service.provider.api;

    uses RawdataClientInitializer;
}
