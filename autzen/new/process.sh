#!/bin/bash

infile="$1"

export GDAL_CACHEMAX=500

read -r -d '' pipeline << EOM
[
    {
        "type": "readers.las",
        "override_srs":"EPSG:2991+6360",
        "filename": "$infile"
    },
    {
      "type":"filters.colorization",
      "raster":"autzen-2009-naip.jpg"
    },
        {
            "type":"writers.las",
            "forward":"all",
            "software_id":"PDAL 2.3.0",
            "system_id":"PDAL",
            "minor_version":"4",
            "dataformat_id":7,
            "pdal_metadata":true,
            "a_srs":"EPSG:2992+6360",
            "filename":"autzen.laz",
            "vlrs":[{"description": "ASPRS Classification Lookup", "record_id": 0, "user_id": "LASF_Spec", "data": "Akdyb3VuZAAAAAAAAAAAAAJHcm91bmQAAAAAAAAAAAAFVmVnZXRhdGlvbgAAAAAABkJ1aWxkaW5nAAAAAAAAAAlXYXRlcgAAAAAAAAAAAAAPVHJhbnNtaXNzaW9uIFRvEUJyaWRnZSBEZWNrAAAAABNPdmVyaGVhZCBTdHJ1Y3RAV2lyZQAAAAAAAAAAAAAAQUNhcgAAAAAAAAAAAAAAAEJUcnVjawAAAAAAAAAAAABDQm9hdAAAAAAAAAAAAAAAREJhcnJpZXIAAAAAAAAAAEVSYWlscm9hZCBDYXIAAABGRWxldmF0ZWQgV2Fsa3dhR0NvdmVyZWQgV2Fsa3dheUhQaWVyL0RvY2sAAAAAAABJRmVuY2UAAAAAAAAAAAAASlRvd2VyAAAAAAAAAAAAAEtDcmFuZQAAAAAAAAAAAABMU2lsby9TdG9yYWdlAAAATUJyaWRnZSBTdHJ1Y3R1cg=="}]
        }
]
EOM


echo $pipeline | pdal pipeline --stdin

pdal translate autzen.laz foo.laz --writers.las.minor_version=2 --writers.las.dataformat_id=3

