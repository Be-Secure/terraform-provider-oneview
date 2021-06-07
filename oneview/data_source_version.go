// (C) Copyright 2021 Hewlett Packard Enterprise Development LP
//
// Licensed under the Apache License, Version 2.0 (the "License");
// You may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

package oneview

import (
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
)

func dataSourceVersion() *schema.Resource {
	return &schema.Resource{
		Read: dataSourceVersionRead,

		Schema: map[string]*schema.Schema{
			"current_version": {
				Type:     schema.TypeInt,
				Computed: true,
			},
			"minimum_version": {
				Type:     schema.TypeInt,
				Computed: true,
			},
		},
	}
}

func dataSourceVersionRead(d *schema.ResourceData, meta interface{}) error {
	config := meta.(*Config)
	ver, err := config.ovClient.GetAPIVersion()

	if err != nil {
		d.SetId("")
		return nil
	}

	d.Set("current_version", ver.CurrentVersion)
	d.Set("minimum_version", ver.MinimumVersion)
	d.SetId(config.OVEndpoint)

	return nil
}