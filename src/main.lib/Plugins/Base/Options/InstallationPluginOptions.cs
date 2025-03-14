﻿using PKISharp.WACS.Plugins.Interfaces;
using PKISharp.WACS.Services;
using PKISharp.WACS.Services.Serialization;
using System;

namespace PKISharp.WACS.Plugins.Base.Options
{
    public class InstallationPluginOptions : PluginOptions
    {
        public override string Name => throw new NotImplementedException();
        public override string Description => throw new NotImplementedException();
        public override Type Instance => throw new NotImplementedException();
    }

    public abstract class InstallationPluginOptions<T> : InstallationPluginOptions where T : IInstallationPlugin
    {
        public abstract override string Name { get; }
        public abstract override string Description { get; }

        public override void Show(IInputService input)
        {
            input.Show(null, "[Installation]");
            input.Show("Plugin", $"{Name} - ({Description})", level: 1);
        }

        public override Type Instance => typeof(T);
    }
}
