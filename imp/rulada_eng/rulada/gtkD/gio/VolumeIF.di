/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = GVolume.html
 * outPack = gio
 * outFile = VolumeIF
 * strct   = GVolume
 * realStrct=
 * ctorStrct=
 * clss    = VolumeT
 * interf  = VolumeIF
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_volume_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gobject.Signals
 * 	- gtkD.gio.AsyncResultIF
 * 	- gtkD.gio.Cancellable
 * 	- gtkD.gio.Drive
 * 	- gtkD.gio.DriveIF
 * 	- gtkD.gio.File
 * 	- gtkD.gio.Icon
 * 	- gtkD.gio.IconIF
 * 	- gtkD.gio.Mount
 * 	- gtkD.gio.MountIF
 * 	- gtkD.gio.MountOperation
 * structWrap:
 * 	- GAsyncResult* -> AsyncResultIF
 * 	- GCancellable* -> Cancellable
 * 	- GDrive* -> DriveIF
 * 	- GFile* -> File
 * 	- GIcon* -> IconIF
 * 	- GMount* -> MountIF
 * 	- GMountOperation* -> MountOperation
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.VolumeIF;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gobject.Signals;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.Drive;
private import gtkD.gio.DriveIF;
private import gtkD.gio.File;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gio.Mount;
private import gtkD.gio.MountIF;
private import gtkD.gio.MountOperation;




/**
 * Description
 * The GVolume interface represents user-visible objects that can be
 * mounted. Note, when porting from GnomeVFS, GVolume is the moral
 * equivalent of GnomeVFSDrive.
 * Mounting a GVolume instance is an asynchronous operation. For more
 * information about asynchronous operations, see GAsyncReady and
 * GSimpleAsyncReady. To mount a GVolume, first call
 * g_volume_mount() with (at least) the GVolume instance, optionally
 * a GMountOperation object and a GAsyncReadyCallback.
 * Typically, one will only want to pass NULL for the
 * GMountOperation if automounting all volumes when a desktop session
 * starts since it's not desirable to put up a lot of dialogs asking
 * for credentials.
 * The callback will be fired when the operation has resolved (either
 * with success or failure), and a GAsyncReady structure will be
 * passed to the callback. That callback should then call
 * g_volume_mount_finish() with the GVolume instance and the
 * GAsyncReady data to see if the operation was completed
 * successfully. If an error is present when g_volume_mount_finish()
 * is called, then it will be filled with any error information.
 * It is sometimes necessary to directly access the underlying
 * operating system object behind a volume (e.g. for passing a volume
 * to an application via the commandline). For this purpose, GIO
 * allows to obtain an 'identifier' for the volume. There can be
 * different kinds of identifiers, such as Hal UDIs, filesystem labels,
 * traditional Unix devices (e.g. /dev/sda2),
 * uuids. GIO uses predefind strings as names for the different kinds
 * of identifiers: G_VOLUME_IDENTIFIER_KIND_HAL_UDI,
 * G_VOLUME_IDENTIFIER_KIND_LABEL, etc. Use g_volume_get_identifier()
 * to obtain an identifier for a volume.
 * Note that G_VOLUME_IDENTIFIER_KIND_HAL_UDI will only be available
 * when the gvfs hal volume monitor is in use. Other volume monitors
 * will generally be able to provide the G_VOLUME_IDENTIFIER_KIND_UNIX_DEVICE
 * identifier, which can be used to obtain a hal device by means of
 * libhal_manger_find_device_string_match().
 */
public interface VolumeIF
{
	
	
	public GVolume* getVolumeTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	void delegate(VolumeIF)[] onChangedListeners();
	/**
	 * Emitted when the volume has been changed.
	 */
	void addOnChanged(void delegate(VolumeIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(VolumeIF)[] onRemovedListeners();
	/**
	 * This signal is emitted when the GVolume have been removed. If
	 * the recipient is holding references to the object they should
	 * release them so the object can be finalized.
	 */
	void addOnRemoved(void delegate(VolumeIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	
	/**
	 * Gets the name of volume.
	 * Returns: the name for the given volume. The returned string should be freed with g_free() when no longer needed.
	 */
	public string getName();
	
	/**
	 * Gets the UUID for the volume. The reference is typically based on
	 * the file system UUID for the volume in question and should be
	 * considered an opaque string. Returns NULL if there is no UUID
	 * available.
	 * Returns: the UUID for volume or NULL if no UUID can be computed. The returned string should be freed with g_free()  when no longer needed.
	 */
	public string getUuid();
	
	/**
	 * Gets the icon for volume.
	 * Returns: a GIcon. The returned object should be unreffed with g_object_unref() when no longer needed.
	 */
	public IconIF getIcon();
	
	/**
	 * Gets the drive for the volume.
	 * Returns: a GDrive or NULL if volume is not associated with a drive. The returned object should be unreffed with g_object_unref() when no longer needed.
	 */
	public DriveIF getDrive();
	
	/**
	 * Gets the mount for the volume.
	 * Returns: a GMount or NULL if volume isn't mounted. The returned object should be unreffed with g_object_unref() when no longer needed.
	 */
	public MountIF getMount();
	
	/**
	 * Checks if a volume can be mounted.
	 * Returns: TRUE if the volume can be mounted. FALSE otherwise.
	 */
	public int canMount();
	
	/**
	 * Returns whether the volume should be automatically mounted.
	 * Returns: TRUE if the volume should be automatically mounted.
	 */
	public int shouldAutomount();
	
	/**
	 * Gets the activation root for a GVolume if it is known ahead of
	 * mount time. Returns NULL otherwise. If not NULL and if volume
	 * is mounted, then the result of g_mount_get_root() on the
	 * GMount object obtained from g_volume_get_mount() will always
	 * either be equal or a prefix of what this function returns. In
	 * other words, in code
	 *  GMount *mount;
	 *  GFile *mount_root
	 *  GFile *volume_activation_root;
	 *  mount = g_volume_get_mount (volume); /+* mounted, so never NULL +/
	 *  mount_root = g_mount_get_root (mount);
	 *  volume_activation_root = g_volume_get_activation_root(volume); /+* assume not NULL +/
	 * then the expression
	 *  (g_file_has_prefix (volume_activation_root, mount_root) ||
	 *  g_file_equal (volume_activation_root, mount_root))
	 * will always be TRUE.
	 * Activation roots are typically used in GVolumeMonitor
	 * implementations to find the underlying mount to shadow, see
	 * g_mount_is_shadowed() for more details.
	 * Since 2.18
	 * Returns: the activation root of volume or NULL. Useg_object_unref() to free.
	 */
	public File getActivationRoot();
	
	/**
	 * Mounts a volume. This is an asynchronous operation, and is
	 * finished by calling g_volume_mount_finish() with the volume
	 * and GAsyncResult returned in the callback.
	 * Params:
	 * flags =  flags affecting the operation
	 * mountOperation =  a GMountOperation or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data that gets passed to callback
	 */
	public void mount(GMountMountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes mounting a volume. If any errors occured during the operation,
	 * error will be set to contain the errors and FALSE will be returned.
	 * If the mount operation succeeded, g_volume_get_mount() on volume
	 * is guaranteed to return the mount right after calling this
	 * function; there's no need to listen for the 'mount-added' signal on
	 * GVolumeMonitor.
	 * Params:
	 * result =  a GAsyncResult
	 * Returns: TRUE, FALSE if operation failed.
	 * Throws: GException on failure.
	 */
	public int mountFinish(AsyncResultIF result);
	
	/**
	 * Checks if a volume can be ejected.
	 * Returns: TRUE if the volume can be ejected. FALSE otherwise.
	 */
	public int canEject();
	
	/**
	 * Warning
	 * g_volume_eject has been deprecated since version 2.22 and should not be used in newly-written code. Use g_volume_eject_with_operation() instead.
	 * Ejects a volume. This is an asynchronous operation, and is
	 * finished by calling g_volume_eject_finish() with the volume
	 * and GAsyncResult returned in the callback.
	 * Params:
	 * flags =  flags affecting the unmount if required for eject
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data that gets passed to callback
	 */
	public void eject(GMountUnmountFlags flags, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Warning
	 * g_volume_eject_finish has been deprecated since version 2.22 and should not be used in newly-written code. Use g_volume_eject_with_operation_finish() instead.
	 * Finishes ejecting a volume. If any errors occured during the operation,
	 * error will be set to contain the errors and FALSE will be returned.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE, FALSE if operation failed.
	 * Throws: GException on failure.
	 */
	public int ejectFinish(AsyncResultIF result);
	
	/**
	 * Ejects a volume. This is an asynchronous operation, and is
	 * finished by calling g_volume_eject_with_operation_finish() with the volume
	 * and GAsyncResult data returned in the callback.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the unmount if required for eject
	 * mountOperation =  a GMountOperation or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data passed to callback.
	 */
	public void ejectWithOperation(GMountUnmountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes ejecting a volume. If any errors occurred during the operation,
	 * error will be set to contain the errors and FALSE will be returned.
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the volume was successfully ejected. FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int ejectWithOperationFinish(AsyncResultIF result);
	
	/**
	 * Gets the kinds of identifiers
	 * that volume has. Use g_volume_get_identifer() to obtain
	 * the identifiers themselves.
	 * Returns: a NULL-terminated array of strings containing kinds of identifiers. Use g_strfreev() to free.
	 */
	public string[] enumerateIdentifiers();
	
	/**
	 * Gets the identifier of the given kind for volume.
	 * See the introduction
	 * for more information about volume identifiers.
	 * Params:
	 * kind =  the kind of identifier to return
	 * Returns: a newly allocated string containing the requested identfier, or NULL if the GVolume doesn't have this kind of identifierSignal DetailsThe "changed" signalvoid user_function (GVolume *arg0, gpointer user_data) : Run LastEmitted when the volume has been changed.
	 */
	public string getIdentifier(string kind);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    }
}
